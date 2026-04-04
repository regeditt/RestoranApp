import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/yazdirma_sonucu_varligi.dart';

class SiparisOzetiSayfasi extends StatefulWidget {
  const SiparisOzetiSayfasi({super.key, required this.sepet, this.qrBaglami});

  final SepetVarligi sepet;
  final QrMenuBaglamiVarligi? qrBaglami;

  @override
  State<SiparisOzetiSayfasi> createState() => _SiparisOzetiSayfasiState();
}

class _SiparisOzetiSayfasiState extends State<SiparisOzetiSayfasi> {
  late final ServisKaydi _servisKaydi;
  bool _servisHazir = false;
  final TextEditingController _adresDenetleyici = TextEditingController();
  final TextEditingController _teslimatNotuDenetleyici =
      TextEditingController();
  bool _kaydediliyor = false;
  bool _varsayilanBilgilerYuklendi = false;
  late TeslimatTipi _seciliTeslimatTipi;

  @override
  void initState() {
    super.initState();
    _seciliTeslimatTipi = widget.qrBaglami?.masaNo != null
        ? TeslimatTipi.restorandaYe
        : TeslimatTipi.gelAl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_servisHazir) {
      return;
    }
    _servisKaydi = ServisSaglayici.of(context);
    _servisHazir = true;
    _varsayilanBilgileriYukle();
  }

  @override
  void dispose() {
    _adresDenetleyici.dispose();
    _teslimatNotuDenetleyici.dispose();
    super.dispose();
  }

  Future<void> _varsayilanBilgileriYukle() async {
    final aktifKullanici = await _servisKaydi.aktifKullaniciGetirUseCase();
    if (!mounted || _varsayilanBilgilerYuklendi) {
      return;
    }

    setState(() {
      _adresDenetleyici.text = aktifKullanici?.adresMetni ?? '';
      _varsayilanBilgilerYuklendi = true;
    });
  }

  Future<void> _siparisiOnayla() async {
    if (_paketServisSeciliMi && _adresDenetleyici.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paket sipariste teslimat adresi gerekli'),
        ),
      );
      return;
    }

    setState(() {
      _kaydediliyor = true;
    });

    try {
      final aktifKullanici = await _servisKaydi.aktifKullaniciGetirUseCase();
      final MisafirBilgisiVarligi misafir = await _servisKaydi
          .misafirOlusturUseCase(
            adSoyad: aktifKullanici?.adSoyad ?? 'Misafir Musteri',
            telefon: aktifKullanici?.telefon ?? '5550000000',
            eposta: aktifKullanici?.eposta,
            adres: aktifKullanici?.adresMetni,
          );

      final DateTime simdi = DateTime.now();
      final SiparisVarligi siparis = SiparisVarligi(
        id: 'sip_${simdi.microsecondsSinceEpoch}',
        siparisNo: 'R-${simdi.millisecondsSinceEpoch.toString().substring(7)}',
        sahip: SiparisSahibiVarligi.misafir(misafir),
        teslimatTipi: _seciliTeslimatTipi,
        durum: SiparisDurumu.alindi,
        kalemler: widget.sepet.kalemler
            .map(
              (kalem) => SiparisKalemiVarligi(
                id: kalem.id,
                urunId: kalem.urun.id,
                urunAdi: kalem.urun.ad,
                birimFiyat: kalem.birimFiyat,
                adet: kalem.adet,
                secenekAdi: kalem.secenekAdi,
                notMetni: kalem.notMetni,
              ),
            )
            .toList(),
        olusturmaTarihi: simdi,
        adresMetni: _paketServisSeciliMi
            ? _adresDenetleyici.text.trim()
            : aktifKullanici?.adresMetni,
        teslimatNotu: _teslimatNotuDenetleyici.text.trim().isEmpty
            ? null
            : _teslimatNotuDenetleyici.text.trim(),
        paketTeslimatDurumu: _paketServisSeciliMi
            ? PaketTeslimatDurumu.adresDogrulandi
            : null,
        masaNo: widget.qrBaglami?.masaNo,
        bolumAdi: widget.qrBaglami?.bolumAdi,
        kaynak: widget.qrBaglami?.kaynak,
      );

      final SiparisVarligi kaydedilenSiparis = await _servisKaydi
          .siparisOlusturUseCase(siparis);
      await _servisKaydi.sipariseGoreStokDusUseCase(kaydedilenSiparis);
      final YazdirmaSonucuVarligi yazdirmaSonucu = await _servisKaydi
          .siparisiYazdirUseCase(kaydedilenSiparis);
      await _servisKaydi.sepetiTemizleUseCase();

      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SuruklenebilirPopupSablonu(
            materialKullan: false,
            child: AlertDialog(
              title: const Text('Siparis alindi'),
              content: Text(
                '${kaydedilenSiparis.siparisNo} numarali siparis kaydedildi. '
                '${_siparisBilgisi(kaydedilenSiparis)}. '
                '${yazdirmaSonucu.ozetMetni}. '
                'Toplam ${kaydedilenSiparis.toplamTutar.toStringAsFixed(0)} TL.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tamam'),
                ),
              ],
            ),
          );
        },
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _kaydediliyor = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Siparis olusturulamadi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);

    return Scaffold(
      backgroundColor: const Color(0xFF140B20),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Siparis Ozeti'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: masaustu
                  ? _ozetKartlari()
                  : ListView(children: [_ozetKartlari()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ozetKartlari() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF241036),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sepet Ozeti',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.sepet.toplamUrunAdedi} urun siparise hazir',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            ...widget.sepet.kalemler.map(_kalemSatiri),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  _ozetRakam('Ara toplam', _paraYaz(widget.sepet.araToplam)),
                  _ozetRakam('Teslimat', _teslimatEtiketi),
                  if (_paketServisSeciliMi) _ozetRakam('Adres', _adresKisaOzet),
                  if (widget.qrBaglami?.masaNo != null)
                    _ozetRakam('Masa', widget.qrBaglami!.masaNo!),
                  if (widget.qrBaglami?.bolumAdi != null)
                    _ozetRakam('Bolum', widget.qrBaglami!.bolumAdi!),
                  _ozetRakam(
                    'Genel toplam',
                    _paraYaz(widget.sepet.araToplam),
                    vurgu: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Misafir siparisi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.qrBaglami?.masaNo != null
                        ? 'QR ile acilan masa baglami bulundu. Siparis varsayilan misafir kaydi ile dogrudan olusturulur ve masa bilgisi siparise eklenir.'
                        : 'Misafir siparisi icin gel al veya paket servis sec. Paket servis secilirse adres ve teslimat notu siparise eklenir.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      height: 1.45,
                    ),
                  ),
                  if (widget.qrBaglami?.masaNo == null) ...[
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _teslimatSecimCipi(
                          etiket: 'Gel al',
                          teslimatTipi: TeslimatTipi.gelAl,
                        ),
                        _teslimatSecimCipi(
                          etiket: 'Paket servis',
                          teslimatTipi: TeslimatTipi.paketServis,
                        ),
                      ],
                    ),
                  ],
                  if (_paketServisSeciliMi) ...[
                    const SizedBox(height: 18),
                    TextField(
                      controller: _adresDenetleyici,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Teslimat adresi',
                        hintText: 'Mahalle, sokak, bina, kat ve daire bilgisi',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _teslimatNotuDenetleyici,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Teslimat notu',
                        hintText: 'Site girisi, zil bilgisi, kurye notu',
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _kaydediliyor ? null : _siparisiOnayla,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5D8F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: _kaydediliyor
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              '${_paraYaz(widget.sepet.araToplam)} ile siparisi tamamla',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kalemSatiri(SepetKalemiVarligi kalem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5D8F).withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              '${kalem.adet}x',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kalem.urun.ad,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (kalem.secenekAdi != null && kalem.secenekAdi!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      kalem.secenekAdi!,
                      style: const TextStyle(
                        color: Color(0xFFFFB6CB),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (kalem.notMetni != null && kalem.notMetni!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      kalem.notMetni!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.62),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            _paraYaz(kalem.araToplam),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ozetRakam(String etiket, String deger, {bool vurgu = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiket,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.64),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          deger,
          style: TextStyle(
            color: vurgu ? const Color(0xFFFFB6CB) : Colors.white,
            fontSize: vurgu ? 22 : 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _teslimatSecimCipi({
    required String etiket,
    required TeslimatTipi teslimatTipi,
  }) {
    final bool secili = _seciliTeslimatTipi == teslimatTipi;
    return ChoiceChip(
      selected: secili,
      label: Text(etiket),
      onSelected: (_) {
        setState(() {
          _seciliTeslimatTipi = teslimatTipi;
        });
      },
      labelStyle: TextStyle(
        color: secili ? const Color(0xFF140B20) : Colors.white,
        fontWeight: FontWeight.w800,
      ),
      selectedColor: const Color(0xFFFFB6CB),
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
    );
  }

  String get _teslimatEtiketi {
    switch (_seciliTeslimatTipi) {
      case TeslimatTipi.restorandaYe:
        return 'Restoranda ye';
      case TeslimatTipi.gelAl:
        return 'Gel al';
      case TeslimatTipi.paketServis:
        return 'Paket servis';
    }
  }

  String _siparisBilgisi(SiparisVarligi siparis) {
    if (siparis.masaNo != null && siparis.masaNo!.isNotEmpty) {
      return 'Masa ${siparis.masaNo} icin kaydedildi';
    }
    if (siparis.teslimatTipi == TeslimatTipi.paketServis) {
      return 'Paket siparis ${siparis.adresMetni ?? 'adrese'} yonlendirildi';
    }
    return 'Siparis kaydedildi';
  }

  bool get _paketServisSeciliMi =>
      _seciliTeslimatTipi == TeslimatTipi.paketServis;

  String get _adresKisaOzet {
    final String adres = _adresDenetleyici.text.trim();
    if (adres.isEmpty) {
      return 'Adres bekleniyor';
    }
    if (adres.length <= 26) {
      return adres;
    }
    return '${adres.substring(0, 26)}...';
  }
}

String _paraYaz(double tutar) {
  final String tamSayi = tutar.toStringAsFixed(2).replaceAll('.', ',');
  return '$tamSayi TL';
}
