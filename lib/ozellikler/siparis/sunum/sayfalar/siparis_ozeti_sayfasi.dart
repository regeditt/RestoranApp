import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/siparis_ozeti_viewmodel.dart';

class SiparisOzetiSayfasi extends StatefulWidget {
  const SiparisOzetiSayfasi({super.key, required this.viewModel});

  final SiparisOzetiViewModel viewModel;

  @override
  State<SiparisOzetiSayfasi> createState() => _SiparisOzetiSayfasiState();
}

class _SiparisOzetiSayfasiState extends State<SiparisOzetiSayfasi> {
  final TextEditingController _adresDenetleyici = TextEditingController();
  final TextEditingController _teslimatNotuDenetleyici =
      TextEditingController();

  SepetVarligi get _sepet => widget.viewModel.sepet;
  QrMenuBaglamiVarligi? get _qrBaglami => widget.viewModel.qrBaglami;
  bool get _kaydediliyor => widget.viewModel.kaydediliyor;
  TeslimatTipi get _seciliTeslimatTipi => widget.viewModel.seciliTeslimatTipi;
  bool get _paketServisSeciliMi => widget.viewModel.paketServisSeciliMi;
  String get _teslimatEtiketi => widget.viewModel.teslimatEtiketi;
  String get _adresKisaOzet => widget.viewModel.adresKisaOzet;

  @override
  void initState() {
    super.initState();
    _adresDenetleyici.addListener(_adresDegisimiDinle);
    _teslimatNotuDenetleyici.addListener(_teslimatNotuDegisimiDinle);
    _varsayilanBilgileriYukle();
  }

  @override
  void didUpdateWidget(covariant SiparisOzetiSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.dispose();
      _adresDenetleyici.text = widget.viewModel.adresMetni;
      _teslimatNotuDenetleyici.text = widget.viewModel.teslimatNotu;
      _varsayilanBilgileriYukle();
    }
  }

  @override
  void dispose() {
    _adresDenetleyici.removeListener(_adresDegisimiDinle);
    _teslimatNotuDenetleyici.removeListener(_teslimatNotuDegisimiDinle);
    _adresDenetleyici.dispose();
    _teslimatNotuDenetleyici.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _varsayilanBilgileriYukle() async {
    final SiparisOzetiIslemSonucu sonuc = await widget.viewModel
        .varsayilanBilgileriYukle();
    if (!mounted) {
      return;
    }

    if (!sonuc.basarili) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
      return;
    }

    _adresDenetleyici.text = widget.viewModel.adresMetni;
    _teslimatNotuDenetleyici.text = widget.viewModel.teslimatNotu;
  }

  void _adresDegisimiDinle() {
    widget.viewModel.adresDegisti(_adresDenetleyici.text);
  }

  void _teslimatNotuDegisimiDinle() {
    widget.viewModel.teslimatNotuDegisti(_teslimatNotuDenetleyici.text);
  }

  Future<void> _siparisiOnayla() async {
    final SiparisOzetiIslemSonucu sonuc = await widget.viewModel
        .siparisiOnayla();
    if (!mounted) {
      return;
    }

    if (!sonuc.basarili ||
        sonuc.siparis == null ||
        sonuc.yazdirmaSonucu == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
      return;
    }

    final SiparisVarligi kaydedilenSiparis = sonuc.siparis!;
    final yazdirmaSonucu = sonuc.yazdirmaSonucu!;
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
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
      },
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
              '${_sepet.toplamUrunAdedi} urun siparise hazir',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            ..._sepet.kalemler.map(_kalemSatiri),
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
                  _ozetRakam('Ara toplam', _paraYaz(_sepet.araToplam)),
                  _ozetRakam('Teslimat', _teslimatEtiketi),
                  if (_paketServisSeciliMi) _ozetRakam('Adres', _adresKisaOzet),
                  if (_qrBaglami?.masaNo != null)
                    _ozetRakam('Masa', _qrBaglami!.masaNo!),
                  if (_qrBaglami?.bolumAdi != null)
                    _ozetRakam('Bolum', _qrBaglami!.bolumAdi!),
                  _ozetRakam(
                    'Genel toplam',
                    _paraYaz(_sepet.araToplam),
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
                    _qrBaglami?.masaNo != null
                        ? 'QR ile acilan masa baglami bulundu. Siparis varsayilan misafir kaydi ile dogrudan olusturulur ve masa bilgisi siparise eklenir.'
                        : 'Misafir siparisi icin gel al veya paket servis sec. Paket servis secilirse adres ve teslimat notu siparise eklenir.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      height: 1.45,
                    ),
                  ),
                  if (_qrBaglami?.masaNo == null) ...[
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
                              '${_paraYaz(_sepet.araToplam)} ile siparisi tamamla',
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
      onSelected: (_) => widget.viewModel.teslimatTipiSec(teslimatTipi),
      labelStyle: TextStyle(
        color: secili ? const Color(0xFF140B20) : Colors.white,
        fontWeight: FontWeight.w800,
      ),
      selectedColor: const Color(0xFFFFB6CB),
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
    );
  }

  String _siparisBilgisi(SiparisVarligi siparis) =>
      widget.viewModel.siparisBilgisi(siparis);
}

String _paraYaz(double tutar) {
  final String tamSayi = tutar.toStringAsFixed(2).replaceAll('.', ',');
  return '$tamSayi TL';
}
