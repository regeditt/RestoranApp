import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/ana_sayfaya_donus.dart';
import 'package:restoran_app/ortak/bilesenler/kvkk_aydinlatma_dialogu.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
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
  final TextEditingController _kuponDenetleyici = TextEditingController();

  SepetVarligi get _sepet => widget.viewModel.sepet;
  QrMenuBaglamiVarligi? get _qrBaglami => widget.viewModel.qrBaglami;
  bool get _kaydediliyor => widget.viewModel.kaydediliyor;
  bool get _kuponIsleniyor => widget.viewModel.kuponIsleniyor;
  bool get _aydinlatmaOnayi => widget.viewModel.aydinlatmaOnayi;
  bool get _ticariIletisimOnayi => widget.viewModel.ticariIletisimOnayi;
  TeslimatTipi get _seciliTeslimatTipi => widget.viewModel.seciliTeslimatTipi;
  bool get _paketServisSeciliMi => widget.viewModel.paketServisSeciliMi;
  String get _teslimatEtiketi => widget.viewModel.teslimatEtiketi;
  String get _adresKisaOzet => widget.viewModel.adresKisaOzet;
  bool get _kuponUygulandiMi => widget.viewModel.kuponUygulandiMi;
  bool get _kuponHataliMi => widget.viewModel.kuponHataliMi;
  String? get _kuponMesaji => widget.viewModel.kuponMesaji;
  double get _indirimTutari => widget.viewModel.indirimTutari;
  double get _genelToplam => widget.viewModel.genelToplam;

  @override
  void initState() {
    super.initState();
    _adresDenetleyici.addListener(_adresDegisimiDinle);
    _teslimatNotuDenetleyici.addListener(_teslimatNotuDegisimiDinle);
    _kuponDenetleyici.text = widget.viewModel.aktifKuponKodu;
    _varsayilanBilgileriYukle();
  }

  @override
  void didUpdateWidget(covariant SiparisOzetiSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.dispose();
      _adresDenetleyici.text = widget.viewModel.adresMetni;
      _teslimatNotuDenetleyici.text = widget.viewModel.teslimatNotu;
      _kuponDenetleyici.text = widget.viewModel.aktifKuponKodu;
      _varsayilanBilgileriYukle();
    }
  }

  @override
  void dispose() {
    _adresDenetleyici.removeListener(_adresDegisimiDinle);
    _teslimatNotuDenetleyici.removeListener(_teslimatNotuDegisimiDinle);
    _adresDenetleyici.dispose();
    _teslimatNotuDenetleyici.dispose();
    _kuponDenetleyici.dispose();
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
    _kuponDenetleyici.text = widget.viewModel.aktifKuponKodu;
  }

  void _adresDegisimiDinle() {
    widget.viewModel.adresDegisti(_adresDenetleyici.text);
  }

  void _teslimatNotuDegisimiDinle() {
    widget.viewModel.teslimatNotuDegisti(_teslimatNotuDenetleyici.text);
  }

  Future<void> _kuponUygula() async {
    final SiparisOzetiIslemSonucu sonuc = await widget.viewModel.kuponUygula(
      _kuponDenetleyici.text,
    );
    if (!mounted) {
      return;
    }
    _kuponDenetleyici.text = widget.viewModel.aktifKuponKodu;
    if (sonuc.basarili) {
      if (sonuc.mesaj.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
      }
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _kuponTemizle() async {
    final SiparisOzetiIslemSonucu sonuc = await widget.viewModel.kuponTemizle();
    if (!mounted) {
      return;
    }
    _kuponDenetleyici.clear();
    if (sonuc.mesaj.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
    }
  }

  void _hizliKuponSec(String kuponKodu) {
    _kuponDenetleyici.text = kuponKodu;
    _kuponDenetleyici.selection = TextSelection.fromPosition(
      TextPosition(offset: _kuponDenetleyici.text.length),
    );
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
            scrollable: true,
            title: const Text('Siparis alindi'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Text(
                '${kaydedilenSiparis.siparisNo} numarali siparis kaydedildi. '
                '${_siparisBilgisi(kaydedilenSiparis)}. '
                '${yazdirmaSonucu.ozetMetni}. '
                'Toplam ${_genelToplam.toStringAsFixed(0)} TL.',
              ),
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
        return Scaffold(
          backgroundColor: AnaSayfaRenkSablonu.arkaPlanKoyu,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: const Text('Siparis Ozeti'),
            actions: [
              IconButton(
                onPressed: () => anaSayfayaDon(context),
                tooltip: 'Ana sayfaya don',
                icon: const Icon(Icons.home_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(child: _ozetKartlari()),
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
        color: AnaSayfaRenkSablonu.panelKoyu,
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
                  _ozetRakam(
                    'Kupon',
                    widget.viewModel.aktifKuponKodu.isEmpty
                        ? '-'
                        : widget.viewModel.aktifKuponKodu,
                  ),
                  _ozetRakam('Indirim', _paraYaz(_indirimTutari)),
                  if (_paketServisSeciliMi) _ozetRakam('Adres', _adresKisaOzet),
                  if (_qrBaglami?.masaNo != null)
                    _ozetRakam('Masa', _qrBaglami!.masaNo!),
                  if (_qrBaglami?.bolumAdi != null)
                    _ozetRakam('Bolum', _qrBaglami!.bolumAdi!),
                  _ozetRakam(
                    'Genel toplam',
                    _paraYaz(_genelToplam),
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
                    'Kampanya ve kupon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ornek kuponlar: HOSGELDIN50, YUZDE10, IKIALBIR, HAFTAICI15',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _kuponDenetleyici,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Kupon kodu',
                      hintText: 'Kod girip uygula',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _hizliKuponCipi('HOSGELDIN50'),
                      _hizliKuponCipi('YUZDE10'),
                      _hizliKuponCipi('IKIALBIR'),
                      _hizliKuponCipi('HAFTAICI15'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: _kuponIsleniyor ? null : _kuponUygula,
                        icon: _kuponIsleniyor
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.local_offer_rounded),
                        label: const Text('Kuponu uygula'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: _kuponIsleniyor ? null : _kuponTemizle,
                        icon: const Icon(Icons.clear_rounded),
                        label: const Text('Temizle'),
                      ),
                    ],
                  ),
                  if (_kuponMesaji != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _kuponMesaji!,
                      style: TextStyle(
                        color: _kuponHataliMi
                            ? AnaSayfaRenkSablonu.panelAlarm
                            : AnaSayfaRenkSablonu.metinIkincil,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (_kuponUygulandiMi) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Kupon indirimi: -${_paraYaz(_indirimTutari)}',
                      style: const TextStyle(
                        color: AnaSayfaRenkSablonu.metinIkincil,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _kaydediliyor
                          ? null
                          : () {
                              KvkkAydinlatmaDialogu.goster(
                                context,
                                baglam: AydinlatmaBaglami.siparis,
                              );
                            },
                      icon: const Icon(Icons.info_outline_rounded),
                      label: const Text('Aydinlatma detaylarini gor'),
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _aydinlatmaOnayi,
                    title: const Text(
                      'KVKK aydinlatma metnini okudum ve onayliyorum (zorunlu)',
                      style: TextStyle(color: Colors.white),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: _kaydediliyor
                        ? null
                        : (bool? deger) {
                            widget.viewModel.aydinlatmaOnayiDegisti(
                              deger ?? false,
                            );
                          },
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _ticariIletisimOnayi,
                    title: const Text(
                      'Kampanya ve bilgilendirme iletileri almak istiyorum (opsiyonel)',
                      style: TextStyle(color: Colors.white),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: _kaydediliyor
                        ? null
                        : (bool? deger) {
                            widget.viewModel.ticariIletisimOnayiDegisti(
                              deger ?? false,
                            );
                          },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _kaydediliyor ? null : _siparisiOnayla,
                      style: FilledButton.styleFrom(
                        backgroundColor: AnaSayfaRenkSablonu.birincilAksiyon,
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
                              '${_paraYaz(_genelToplam)} ile siparisi tamamla',
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
              color: AnaSayfaRenkSablonu.birincilAksiyon.withValues(
                alpha: 0.16,
              ),
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
                        color: AnaSayfaRenkSablonu.metinIkincil,
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
            color: vurgu ? AnaSayfaRenkSablonu.metinIkincil : Colors.white,
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
        color: secili ? AnaSayfaRenkSablonu.arkaPlanKoyu : Colors.white,
        fontWeight: FontWeight.w800,
      ),
      selectedColor: AnaSayfaRenkSablonu.metinIkincil,
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
    );
  }

  Widget _hizliKuponCipi(String kuponKodu) {
    return ActionChip(
      label: Text(kuponKodu),
      onPressed: () => _hizliKuponSec(kuponKodu),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
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
