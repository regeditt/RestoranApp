import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
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
  final ServisKaydi _servisKaydi = ServisKaydi.ortak;
  bool _kaydediliyor = false;

  Future<void> _siparisiOnayla() async {
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
        teslimatTipi: _teslimatTipi,
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
          return AlertDialog(
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
                        : 'Musteri bilgileri bolumu kaldirildi. Siparis varsayilan misafir kaydi ile dogrudan olusturulur.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      height: 1.45,
                    ),
                  ),
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

  TeslimatTipi get _teslimatTipi {
    return widget.qrBaglami?.masaNo != null
        ? TeslimatTipi.restorandaYe
        : TeslimatTipi.gelAl;
  }

  String get _teslimatEtiketi {
    return _teslimatTipi == TeslimatTipi.restorandaYe
        ? 'Restoranda ye'
        : 'Gel al';
  }

  String _siparisBilgisi(SiparisVarligi siparis) {
    if (siparis.masaNo != null && siparis.masaNo!.isNotEmpty) {
      return 'Masa ${siparis.masaNo} icin kaydedildi';
    }
    return 'Siparis kaydedildi';
  }
}

String _paraYaz(double tutar) {
  final String tamSayi = tutar.toStringAsFixed(2).replaceAll('.', ',');
  return '$tamSayi TL';
}
