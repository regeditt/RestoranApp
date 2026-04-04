import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_karti_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_baglami_cozumleyici.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_pdf_servisi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_formlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_kartlari.dart';
import 'package:url_launcher/url_launcher.dart';

class YonetimAyarlariDialog extends StatefulWidget {
  const YonetimAyarlariDialog({
    super.key,
    required this.salonBolumleri,
    required this.menuKategorileri,
    required this.menuUrunleri,
    required this.veriYenile,
    required this.servisKaydi,
    required this.baslangicSekmesi,
  });

  final List<SalonBolumuVarligi> salonBolumleri;
  final List<KategoriVarligi> menuKategorileri;
  final List<UrunVarligi> menuUrunleri;
  final Future<void> Function() veriYenile;
  final ServisKaydi servisKaydi;
  final int baslangicSekmesi;

  @override
  State<YonetimAyarlariDialog> createState() => _YonetimAyarlariDialogState();
}

class _YonetimAyarlariDialogState extends State<YonetimAyarlariDialog> {
  late List<SalonBolumuVarligi> _salonBolumleri;
  late List<KategoriVarligi> _menuKategorileri;
  late List<UrunVarligi> _menuUrunleri;
  List<HammaddeStokVarligi> _hammaddeler = const <HammaddeStokVarligi>[];
  Map<String, List<ReceteKalemiVarligi>> _urunReceteleri =
      const <String, List<ReceteKalemiVarligi>>{};

  @override
  void initState() {
    super.initState();
    _salonBolumleri = widget.salonBolumleri;
    _menuKategorileri = widget.menuKategorileri;
    _menuUrunleri = widget.menuUrunleri;
    _stokVerileriniYukle();
  }

  Future<void> _stokVerileriniYukle() async {
    final List<HammaddeStokVarligi> hammaddeler = await widget.servisKaydi
        .hammaddeleriGetirUseCase();
    final Map<String, List<ReceteKalemiVarligi>> urunReceteleri =
        await _urunReceteleriniYukle(_menuUrunleri);
    if (!mounted) {
      return;
    }
    setState(() {
      _hammaddeler = hammaddeler;
      _urunReceteleri = urunReceteleri;
    });
  }

  Future<Map<String, List<ReceteKalemiVarligi>>> _urunReceteleriniYukle(
    List<UrunVarligi> urunler,
  ) async {
    final Map<String, List<ReceteKalemiVarligi>> receteler =
        <String, List<ReceteKalemiVarligi>>{};
    for (final UrunVarligi urun in urunler) {
      receteler[urun.id] = await widget.servisKaydi.receteyiGetirUseCase(
        urun.id,
      );
    }
    return receteler;
  }

  Future<void> _yenile() async {
    await widget.veriYenile();
    final List<SalonBolumuVarligi> salonBolumleri = await widget.servisKaydi
        .salonBolumleriniGetirUseCase();
    final List<KategoriVarligi> menuKategorileri = await widget.servisKaydi
        .kategorileriGetirUseCase();
    final List<UrunVarligi> menuUrunleri = await widget.servisKaydi
        .urunleriGetirUseCase();
    final List<HammaddeStokVarligi> hammaddeler = await widget.servisKaydi
        .hammaddeleriGetirUseCase();
    final Map<String, List<ReceteKalemiVarligi>> urunReceteleri =
        await _urunReceteleriniYukle(menuUrunleri);

    if (!mounted) {
      return;
    }

    setState(() {
      _salonBolumleri = salonBolumleri;
      _menuKategorileri = menuKategorileri;
      _menuUrunleri = menuUrunleri;
      _hammaddeler = hammaddeler;
      _urunReceteleri = urunReceteleri;
    });
  }

  Future<void> _bolumEkle() async {
    final SalonBolumuFormSonucu? sonuc =
        await showDialog<SalonBolumuFormSonucu>(
          context: context,
          builder: (BuildContext context) => const SalonBolumuFormDialog(),
        );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.salonBolumuEkleUseCase(
      SalonBolumuVarligi(
        id: 'blm_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        aciklama: sonuc.aciklama,
      ),
    );
    await _yenile();
  }

  Future<void> _bolumDuzenle(SalonBolumuVarligi bolum) async {
    final SalonBolumuFormSonucu? sonuc =
        await showDialog<SalonBolumuFormSonucu>(
          context: context,
          builder: (BuildContext context) =>
              SalonBolumuFormDialog(baslangicBolumu: bolum),
        );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.salonBolumuGuncelleUseCase(
      bolum.copyWith(ad: sonuc.ad, aciklama: sonuc.aciklama),
    );
    await _yenile();
  }

  Future<void> _bolumSil(SalonBolumuVarligi bolum) async {
    await widget.servisKaydi.salonBolumuSilUseCase(bolum.id);
    await _yenile();
  }

  Future<void> _masaEkle(SalonBolumuVarligi bolum) async {
    final MasaFormSonucu? sonuc = await showDialog<MasaFormSonucu>(
      context: context,
      builder: (BuildContext context) => MasaFormDialog(bolumAdi: bolum.ad),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.masaEkleUseCase(
      bolum.id,
      MasaTanimiVarligi(
        id: 'masa_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        kapasite: sonuc.kapasite,
      ),
    );
    await _yenile();
  }

  Future<void> _masaDuzenle(
    SalonBolumuVarligi bolum,
    MasaTanimiVarligi masa,
  ) async {
    final MasaFormSonucu? sonuc = await showDialog<MasaFormSonucu>(
      context: context,
      builder: (BuildContext context) =>
          MasaFormDialog(bolumAdi: bolum.ad, baslangicMasasi: masa),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.masaGuncelleUseCase(
      bolumId: bolum.id,
      masa: masa.copyWith(ad: sonuc.ad, kapasite: sonuc.kapasite),
    );
    await _yenile();
  }

  Future<void> _masaSil(
    SalonBolumuVarligi bolum,
    MasaTanimiVarligi masa,
  ) async {
    await widget.servisKaydi.masaSilUseCase(bolumId: bolum.id, masaId: masa.id);
    await _yenile();
  }

  Future<void> _masaQrBaglamiAc(
    SalonBolumuVarligi bolum,
    MasaTanimiVarligi masa,
  ) async {
    final String qrUrl = _masaQrUrliniOlustur(bolum, masa);
    final QrMenuKartiVarligi qrKarti = QrMenuKartiVarligi(
      baslik: 'Masa ${masa.ad}',
      altBaslik: bolum.ad,
      url: qrUrl,
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SuruklenebilirPopupSablonu(
          child: AlertDialog(
            title: Text('Masa ${masa.ad} QR baglami'),
            content: SizedBox(
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${bolum.ad} bolumu icin gercek QR menu adresi hazir.',
                    style: const TextStyle(color: Color(0xFF6D6079)),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFDF7FB), Color(0xFFFFFFFF)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE4D8EE)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCE3EC),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              UygulamaSabitleri.tamMarkaAdi,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                color: Color(0xFFA13A63),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          QrImageView(
                            data: qrUrl,
                            version: QrVersions.auto,
                            size: 220,
                            backgroundColor: Colors.white,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Color(0xFF221530),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Color(0xFF221530),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Masa ${masa.ad}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Color(0xFF2D2140),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bolum.ad,
                            style: const TextStyle(
                              color: Color(0xFF6D6079),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tarat ve masaya ozel menuye ulas',
                            style: TextStyle(
                              color: const Color(
                                0xFF6D6079,
                              ).withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4EEF8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SelectableText(
                      qrUrl,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2140),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text('Masa ${masa.ad}')),
                      Chip(label: Text('Bolum ${bolum.ad}')),
                      const Chip(label: Text('Kaynak qr')),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Kapat'),
              ),
              FilledButton.tonalIcon(
                onPressed: () async {
                  final NavigatorState gezgin = Navigator.of(dialogContext);
                  final bool acildi = await _qrLinkiniAc(qrUrl);
                  if (!mounted) {
                    return;
                  }
                  if (!acildi) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('QR menu adresi acilamadi')),
                    );
                    return;
                  }
                  gezgin.pop();
                },
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Ac'),
              ),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await QrMenuPdfServisi.kartlariYazdir(
                    belgeBasligi: 'Masa ${masa.ad} QR Karti',
                    kartlar: <QrMenuKartiVarligi>[qrKarti],
                  );
                },
                icon: const Icon(Icons.print_rounded),
                label: const Text('Yazdir / PDF'),
              ),
              FilledButton.icon(
                onPressed: () async {
                  final NavigatorState gezgin = Navigator.of(dialogContext);
                  await Clipboard.setData(ClipboardData(text: qrUrl));
                  if (!mounted) {
                    return;
                  }
                  gezgin.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Masa ${masa.ad} icin QR linki panoya kopyalandi',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Linki kopyala'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _topluQrSayfasiniAc() async {
    final List<QrMenuKartiVarligi> kartlar = _tumMasaQrKartlari;
    if (kartlar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toplu QR icin masa bulunamadi')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SuruklenebilirPopupSablonu(
          materialKullan: false,
          tutamacUstOfset: 24,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Material(
                color: Theme.of(dialogContext).colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: 980,
                  height: 720,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Toplu QR sayfasi',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Tum masalarin taranabilir QR kartlari tek yerde gorunur.',
                                    style: TextStyle(color: Color(0xFF6D6079)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.tonalIcon(
                              onPressed: () async {
                                await QrMenuPdfServisi.kartlariYazdir(
                                  belgeBasligi: 'Toplu Masa QR Kartlari',
                                  kartlar: kartlar,
                                );
                              },
                              icon: const Icon(Icons.print_rounded),
                              label: const Text('Toplu yazdir'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.tonalIcon(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: _topluQrMetniOlustur(kartlar),
                                  ),
                                );
                                if (!mounted) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Tum masa QR linkleri panoya kopyalandi',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy_all_rounded),
                              label: const Text('Tum linkleri kopyala'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: const Text('Kapat'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: kartlar.map((QrMenuKartiVarligi kart) {
                                return TopluQrKarti(kart: kart);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _masaQrUrliniOlustur(
    SalonBolumuVarligi bolum,
    MasaTanimiVarligi masa,
  ) {
    final Uri tabanUri = Uri.base;
    final String tabanUrl = tabanUri.hasScheme && tabanUri.host.isNotEmpty
        ? '${tabanUri.scheme}://${tabanUri.authority}'
        : UygulamaSabitleri.varsayilanQrTabanUrl;

    return QrMenuBaglamiCozumleyici.qrUrlOlustur(
      tabanUrl: tabanUrl,
      masaNo: masa.ad,
      bolumAdi: bolum.ad.toLowerCase().replaceAll(' ', '_'),
      kaynak: 'qr',
    );
  }

  Future<bool> _qrLinkiniAc(String qrUrl) async {
    final Uri uri = Uri.parse(qrUrl);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  List<QrMenuKartiVarligi> get _tumMasaQrKartlari {
    final List<QrMenuKartiVarligi> kartlar = <QrMenuKartiVarligi>[];
    for (final SalonBolumuVarligi bolum in _salonBolumleri) {
      for (final MasaTanimiVarligi masa in bolum.masalar) {
        kartlar.add(
          QrMenuKartiVarligi(
            baslik: 'Masa ${masa.ad}',
            altBaslik: bolum.ad,
            url: _masaQrUrliniOlustur(bolum, masa),
          ),
        );
      }
    }
    return kartlar;
  }

  String _topluQrMetniOlustur(List<QrMenuKartiVarligi> kartlar) {
    return kartlar
        .map(
          (QrMenuKartiVarligi kart) =>
              '${kart.baslik} | ${kart.altBaslik}\n${kart.url}',
        )
        .join('\n\n');
  }

  Future<void> _kategoriEkle() async {
    final KategoriFormSonucu? sonuc = await showDialog<KategoriFormSonucu>(
      context: context,
      builder: (BuildContext context) => const KategoriFormDialog(),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.kategoriEkleUseCase(
      KategoriVarligi(
        id: 'kat_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        sira: _menuKategorileri.length + 1,
      ),
    );
    await _yenile();
  }

  Future<void> _kategoriDuzenle(KategoriVarligi kategori) async {
    final KategoriFormSonucu? sonuc = await showDialog<KategoriFormSonucu>(
      context: context,
      builder: (BuildContext context) =>
          KategoriFormDialog(baslangicKategori: kategori),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.kategoriGuncelleUseCase(
      kategori.copyWith(ad: sonuc.ad),
    );
    await _yenile();
  }

  Future<void> _kategoriSil(KategoriVarligi kategori) async {
    await widget.servisKaydi.kategoriSilUseCase(kategori.id);
    await _yenile();
  }

  Future<void> _urunEkle([UrunVarligi? urun]) async {
    if (_menuKategorileri.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Once bir kategori eklemelisin.')),
      );
      return;
    }
    final UrunFormSonucu? sonuc = await showDialog<UrunFormSonucu>(
      context: context,
      builder: (BuildContext context) =>
          UrunFormDialog(kategoriler: _menuKategorileri, urun: urun),
    );
    if (sonuc == null) {
      return;
    }
    if (urun == null) {
      await widget.servisKaydi.urunEkleUseCase(
        UrunVarligi(
          id: 'urn_${DateTime.now().microsecondsSinceEpoch}',
          kategoriId: sonuc.kategoriId,
          ad: sonuc.ad,
          aciklama: sonuc.aciklama,
          fiyat: sonuc.fiyat,
          stoktaMi: sonuc.stoktaMi,
          oneCikanMi: sonuc.oneCikanMi,
        ),
      );
    } else {
      await widget.servisKaydi.urunGuncelleUseCase(
        urun.copyWith(
          kategoriId: sonuc.kategoriId,
          ad: sonuc.ad,
          aciklama: sonuc.aciklama,
          fiyat: sonuc.fiyat,
          stoktaMi: sonuc.stoktaMi,
          oneCikanMi: sonuc.oneCikanMi,
        ),
      );
    }
    await _yenile();
  }

  Future<void> _urunSil(UrunVarligi urun) async {
    await widget.servisKaydi.urunSilUseCase(urun.id);
    await _yenile();
  }

  Future<void> _hammaddeEkle() async {
    final HammaddeFormSonucu? sonuc = await showDialog<HammaddeFormSonucu>(
      context: context,
      builder: (BuildContext context) => const HammaddeFormDialog(),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.hammaddeEkleUseCase(
      HammaddeStokVarligi(
        id: 'ham_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        birim: sonuc.birim,
        mevcutMiktar: sonuc.mevcutMiktar,
        kritikEsik: sonuc.kritikEsik,
        birimMaliyet: sonuc.birimMaliyet,
      ),
    );
    await _yenile();
  }

  Future<void> _hammaddeDuzenle(HammaddeStokVarligi hammadde) async {
    final HammaddeFormSonucu? sonuc = await showDialog<HammaddeFormSonucu>(
      context: context,
      builder: (BuildContext context) =>
          HammaddeFormDialog(baslangicHammadde: hammadde),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.hammaddeGuncelleUseCase(
      hammadde.copyWith(
        ad: sonuc.ad,
        birim: sonuc.birim,
        mevcutMiktar: sonuc.mevcutMiktar,
        kritikEsik: sonuc.kritikEsik,
        birimMaliyet: sonuc.birimMaliyet,
      ),
    );
    await _yenile();
  }

  Future<void> _urunRecetesiniDuzenle(UrunVarligi urun) async {
    final List<ReceteKalemiVarligi> baslangicRecetesi =
        _urunReceteleri[urun.id] ?? const <ReceteKalemiVarligi>[];
    final List<ReceteKalemiVarligi>? sonuc =
        await showDialog<List<ReceteKalemiVarligi>>(
          context: context,
          builder: (BuildContext context) => ReceteDuzenlemeDialog(
            urun: urun,
            hammaddeler: _hammaddeler,
            baslangicRecetesi: baslangicRecetesi,
          ),
        );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.receteyiKaydetUseCase(urun.id, sonuc);
    await _yenile();

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${urun.ad} recetesi guncellendi')));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.baslangicSekmesi,
      child: SuruklenebilirPopupSablonu(
        materialKullan: false,
        tutamacUstOfset: 140,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1120,
                  maxHeight: 760,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Admin ayarlari',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Salon, masa, menu ve stok duzenini buradan yonetebilirsin.',
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4EEF8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const TabBar(
                          tabs: [
                            Tab(text: 'Salon'),
                            Tab(text: 'Menu'),
                            Tab(text: 'Stok'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: TabBarView(
                          children: [
                            AyarlarKarti(
                              baslik: 'Salon ve masa yonetimi',
                              aciklama:
                                  'Bolum ekle, masa kapasitesini tanimla ve gerekmeyen masalari kaldir.',
                              eylem: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilledButton.icon(
                                    onPressed: _bolumEkle,
                                    icon: const Icon(
                                      Icons.add_business_rounded,
                                    ),
                                    label: const Text('Bolum ekle'),
                                  ),
                                  FilledButton.tonalIcon(
                                    onPressed: _topluQrSayfasiniAc,
                                    icon: const Icon(Icons.qr_code_2_rounded),
                                    label: const Text('Toplu QR sayfasi'),
                                  ),
                                ],
                              ),
                              child: ListView(
                                children: _salonBolumleri
                                    .map(
                                      (SalonBolumuVarligi bolum) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: AdminBolumKarti(
                                          bolum: bolum,
                                          masaEkle: () => _masaEkle(bolum),
                                          bolumDuzenle: () =>
                                              _bolumDuzenle(bolum),
                                          bolumSil: () => _bolumSil(bolum),
                                          qrBaglamiAc:
                                              (MasaTanimiVarligi masa) =>
                                                  _masaQrBaglamiAc(bolum, masa),
                                          masaDuzenle:
                                              (MasaTanimiVarligi masa) =>
                                                  _masaDuzenle(bolum, masa),
                                          masaSil: (MasaTanimiVarligi masa) =>
                                              _masaSil(bolum, masa),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            AyarlarKarti(
                              baslik: 'Menu yonetimi',
                              aciklama:
                                  'Kategori ve urunleri canli olarak duzenle, fiyatlari guncelle.',
                              eylem: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilledButton.icon(
                                    onPressed: _kategoriEkle,
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Kategori ekle'),
                                  ),
                                  FilledButton.tonalIcon(
                                    onPressed: () => _urunEkle(),
                                    icon: const Icon(
                                      Icons.restaurant_menu_rounded,
                                    ),
                                    label: const Text('Urun ekle'),
                                  ),
                                ],
                              ),
                              child: ListView(
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _menuKategorileri
                                        .map(
                                          (KategoriVarligi kategori) =>
                                              InputChip(
                                                label: Text(kategori.ad),
                                                onPressed: () =>
                                                    _kategoriDuzenle(kategori),
                                                onDeleted: () =>
                                                    _kategoriSil(kategori),
                                              ),
                                        )
                                        .toList(),
                                  ),
                                  const SizedBox(height: 16),
                                  ..._menuUrunleri.map(
                                    (UrunVarligi urun) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: AdminUrunSatiri(
                                        urun: urun,
                                        kategoriAdi: _kategoriAdiBul(
                                          urun.kategoriId,
                                        ),
                                        receteOzeti: _receteOzetiniOlustur(
                                          urun.id,
                                        ),
                                        urunDuzenle: () => _urunEkle(urun),
                                        receteDuzenle: () =>
                                            _urunRecetesiniDuzenle(urun),
                                        urunSil: () => _urunSil(urun),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AyarlarKarti(
                              baslik: 'Stok girisi',
                              aciklama:
                                  'Hammadde ekle ve kritik seviyeye yaklasan kalemleri izle.',
                              eylem: FilledButton.icon(
                                onPressed: _hammaddeEkle,
                                icon: const Icon(Icons.inventory_2_rounded),
                                label: const Text('Hammadde ekle'),
                              ),
                              child: ListView(
                                children: _hammaddeler
                                    .map(
                                      (HammaddeStokVarligi hammadde) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: AdminHammaddeSatiri(
                                          hammadde: hammadde,
                                          duzenle: () =>
                                              _hammaddeDuzenle(hammadde),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _kategoriAdiBul(String kategoriId) {
    for (final KategoriVarligi kategori in _menuKategorileri) {
      if (kategori.id == kategoriId) {
        return kategori.ad;
      }
    }
    return 'Kategori yok';
  }

  String _receteOzetiniOlustur(String urunId) {
    final List<ReceteKalemiVarligi> recete =
        _urunReceteleri[urunId] ?? const <ReceteKalemiVarligi>[];
    if (recete.isEmpty) {
      return 'Recete tanimli degil';
    }

    final Map<String, HammaddeStokVarligi> hammaddeHaritasi =
        <String, HammaddeStokVarligi>{
          for (final HammaddeStokVarligi hammadde in _hammaddeler)
            hammadde.id: hammadde,
        };
    final Iterable<String> etiketler = recete.map((ReceteKalemiVarligi kalem) {
      final HammaddeStokVarligi? hammadde = hammaddeHaritasi[kalem.hammaddeId];
      if (hammadde == null) {
        return '${kalem.miktar.toStringAsFixed(1)} bilinmeyen';
      }
      return '${hammadde.ad} ${kalem.miktar.toStringAsFixed(1)} ${hammadde.birim}';
    });
    return etiketler.join(' • ');
  }
}
