import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/veri/veri_aktarim_servisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_backend_ayar_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/bilesenler/giris_asistani_dialogu.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_asistani_viewmodel.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_karti_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_baglami_cozumleyici.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_pdf_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_formlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_kartlari.dart';
import 'package:url_launcher/url_launcher.dart';

enum _MenuYedekAktarimKapsami { tumu, sadeceKategoriler, sadeceUrunler }

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
  late final KuryeEntegrasyonYonetimServisi _kuryeEntegrasyonServisi;

  late List<SalonBolumuVarligi> _salonBolumleri;
  late List<KategoriVarligi> _menuKategorileri;
  late List<UrunVarligi> _menuUrunleri;
  List<HammaddeStokVarligi> _hammaddeler = const <HammaddeStokVarligi>[];
  Map<String, List<ReceteKalemiVarligi>> _urunReceteleri =
      const <String, List<ReceteKalemiVarligi>>{};
  List<KuryeTakipSaglayiciVarligi> _kuryeSaglayicilari =
      const <KuryeTakipSaglayiciVarligi>[];
  List<KuryeCihazEslesmesiVarligi> _kuryeEslesmeleri =
      const <KuryeCihazEslesmesiVarligi>[];
  bool _veriAktarimSuruyor = false;
  String? _sonMenuYedegiJson;
  String _veriAktarimDurumu = 'Yedekleme islemi henuz baslatilmadi.';
  final TextEditingController _asistanBackendUrlDenetleyici =
      TextEditingController();
  final TextEditingController _asistanApiAnahtariDenetleyici =
      TextEditingController();
  bool _asistanApiAnahtariGoster = false;
  bool _asistanAyarKaydediliyor = false;
  bool _asistanBaglantiTestSuruyor = false;
  String _asistanBaglantiDurumu =
      'Chatbot backend URL tanimlanmadi. Sohbet yerel modda calisir.';

  @override
  void initState() {
    super.initState();
    _kuryeEntegrasyonServisi =
        widget.servisKaydi.kuryeEntegrasyonYonetimServisi;
    _salonBolumleri = widget.salonBolumleri;
    _menuKategorileri = widget.menuKategorileri;
    _menuUrunleri = widget.menuUrunleri;
    _stokVerileriniYukle();
    _kuryeEntegrasyonVerileriniYukle();
    _asistanBackendAyariniYukle();
  }

  @override
  void dispose() {
    _asistanBackendUrlDenetleyici.dispose();
    _asistanApiAnahtariDenetleyici.dispose();
    super.dispose();
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

  Future<void> _kuryeEntegrasyonVerileriniYukle() async {
    final List<KuryeTakipSaglayiciVarligi> saglayicilar =
        await _kuryeEntegrasyonServisi.saglayicilariGetir();
    final List<KuryeCihazEslesmesiVarligi> eslesmeler =
        await _kuryeEntegrasyonServisi.kuryeCihazEslesmeleriniGetir();
    if (!mounted) {
      return;
    }
    setState(() {
      _kuryeSaglayicilari = saglayicilar;
      _kuryeEslesmeleri = eslesmeler;
    });
  }

  Future<void> _asistanBackendAyariniYukle() async {
    final AsistanBackendAyarVarligi ayar = await widget.servisKaydi
        .asistanBackendAyariniGetirUseCase();
    if (!mounted) {
      return;
    }
    setState(() {
      _asistanBackendUrlDenetleyici.text = ayar.tabanUrl.trim();
      _asistanApiAnahtariDenetleyici.text = ayar.apiAnahtari.trim();
      _asistanBaglantiDurumu = ayar.tabanUrl.trim().isEmpty
          ? 'Chatbot backend URL tanimlanmadi. Sohbet yerel modda calisir.'
          : ayar.apiAnahtari.trim().isEmpty
          ? 'Kayitli backend URL yuklendi. API anahtari bos.'
          : 'Kayitli backend URL ve API anahtari yuklendi.';
    });
  }

  Future<void> _asistanBackendAyariniKaydet() async {
    final String tabanUrl = _asistanBackendUrlDenetleyici.text.trim();
    final String apiAnahtari = _asistanApiAnahtariDenetleyici.text.trim();
    bool kayitBasarili = true;
    setState(() {
      _asistanAyarKaydediliyor = true;
    });
    try {
      await widget.servisKaydi.asistanBackendAyariniKaydetUseCase(
        tabanUrl: tabanUrl,
        apiAnahtari: apiAnahtari,
      );
    } catch (_) {
      kayitBasarili = false;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _asistanAyarKaydediliyor = false;
      _asistanBaglantiDurumu = kayitBasarili
          ? tabanUrl.isEmpty
                ? 'Backend URL temizlendi. Sohbet yerel modda calisir.'
                : apiAnahtari.isEmpty
                ? 'Backend URL kaydedildi. API anahtari bos.'
                : 'Backend URL ve API anahtari kaydedildi.'
          : 'Kaydetme sirasinda hata olustu. Tekrar deneyebilirsin.';
    });
  }

  Future<void> _asistanBackendBaglantisiniTestEt() async {
    final String tabanUrl = _asistanBackendUrlDenetleyici.text.trim();
    final String apiAnahtari = _asistanApiAnahtariDenetleyici.text.trim();
    if (tabanUrl.isEmpty) {
      setState(() {
        _asistanBaglantiDurumu = 'Test icin once backend URL girmen gerekiyor.';
      });
      return;
    }
    setState(() {
      _asistanBaglantiTestSuruyor = true;
      _asistanBaglantiDurumu = 'Baglanti test ediliyor...';
    });
    bool baglantiVar = false;
    try {
      baglantiVar = await widget.servisKaydi
          .asistanBackendBaglantiTestEtUseCase(
            tabanUrl,
            apiAnahtari: apiAnahtari,
          );
    } catch (_) {
      baglantiVar = false;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _asistanBaglantiTestSuruyor = false;
      _asistanBaglantiDurumu = baglantiVar
          ? 'Baglanti basarili. Chatbot API modunda calisabilir.'
          : 'Baglanti basarisiz. URL veya backend endpointini kontrol et.';
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
    final List<KuryeTakipSaglayiciVarligi> saglayicilar =
        await _kuryeEntegrasyonServisi.saglayicilariGetir();
    final List<KuryeCihazEslesmesiVarligi> eslesmeler =
        await _kuryeEntegrasyonServisi.kuryeCihazEslesmeleriniGetir();

    if (!mounted) {
      return;
    }

    setState(() {
      _salonBolumleri = salonBolumleri;
      _menuKategorileri = menuKategorileri;
      _menuUrunleri = menuUrunleri;
      _hammaddeler = hammaddeler;
      _urunReceteleri = urunReceteleri;
      _kuryeSaglayicilari = saglayicilar;
      _kuryeEslesmeleri = eslesmeler;
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
    final bool yetkili = await _yetkiyiDogrula(
      IslemYetkisi.urunFiyatDegistir,
      hataMesaji: 'Urun fiyatini degistirme yetkin bulunmuyor.',
    );
    if (!yetkili || !mounted) {
      return;
    }
    if (_menuKategorileri.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Once bir kategori eklemelisin.')),
      );
      return;
    }
    if (!mounted) {
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
          gorselUrl: sonuc.gorselUrl,
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
          gorselUrl: sonuc.gorselUrl,
          stoktaMi: sonuc.stoktaMi,
          oneCikanMi: sonuc.oneCikanMi,
        ),
      );
    }
    await _yenile();
  }

  Future<void> _urunSil(UrunVarligi urun) async {
    final bool yetkili = await _yetkiyiDogrula(
      IslemYetkisi.urunFiyatDegistir,
      hataMesaji: 'Menu urunlerini degistirme yetkin bulunmuyor.',
    );
    if (!yetkili) {
      return;
    }
    await widget.servisKaydi.urunSilUseCase(urun.id);
    await _yenile();
  }

  Future<void> _chatbotuAc() {
    final GirisAsistaniViewModel asistanViewModel =
        GirisAsistaniViewModel.servisKaydindan(widget.servisKaydi);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return GirisAsistaniDialog(viewModel: asistanViewModel);
      },
    );
  }

  Future<bool> _yetkiyiDogrula(
    IslemYetkisi yetki, {
    required String hataMesaji,
  }) async {
    final bool yetkili = await widget.servisKaydi.islemYetkisiVarMi(yetki);
    if (!yetkili && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(hataMesaji)));
    }
    return yetkili;
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

  Future<void> _kuryeSaglayicisiniKaydet([
    KuryeTakipSaglayiciVarligi? baslangic,
  ]) async {
    final KuryeSaglayiciFormSonucu? sonuc =
        await showDialog<KuryeSaglayiciFormSonucu>(
          context: context,
          builder: (BuildContext context) =>
              KuryeSaglayiciFormDialog(baslangicSaglayici: baslangic),
        );
    if (sonuc == null) {
      return;
    }

    final KuryeTakipSaglayiciVarligi kayit =
        (baslangic ??
                KuryeTakipSaglayiciVarligi(
                  id: 'sgl_${DateTime.now().microsecondsSinceEpoch}',
                  ad: sonuc.ad,
                  tur: sonuc.tur,
                  apiTabanUrl: sonuc.apiTabanUrl,
                  apiAnahtari: sonuc.apiAnahtari,
                  aktifMi: sonuc.aktifMi,
                  oncelik: _kuryeSaglayicilari.length + 1,
                  aciklama: sonuc.aciklama,
                ))
            .copyWith(
              ad: sonuc.ad,
              tur: sonuc.tur,
              apiTabanUrl: sonuc.apiTabanUrl,
              apiAnahtari: sonuc.apiAnahtari,
              aktifMi: sonuc.aktifMi,
              aciklama: sonuc.aciklama,
            );

    await _kuryeEntegrasyonServisi.saglayiciKaydet(kayit);
    await _kuryeEntegrasyonVerileriniYukle();
  }

  Future<void> _kuryeSaglayicisiniSil(
    KuryeTakipSaglayiciVarligi saglayici,
  ) async {
    final bool? onay = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Saglayiciyi sil'),
          content: Text('${saglayici.ad} kaldirilsin mi?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Vazgec'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
    if (onay != true) {
      return;
    }

    await _kuryeEntegrasyonServisi.saglayiciSil(saglayici.id);
    await _kuryeEntegrasyonVerileriniYukle();
  }

  Future<void> _kuryeSaglayicisiniAktifYap(
    KuryeTakipSaglayiciVarligi saglayici,
  ) async {
    await _kuryeEntegrasyonServisi.aktifSaglayiciYap(saglayici.id);
    await _kuryeEntegrasyonVerileriniYukle();
  }

  Future<void> _kuryeSaglayiciOnceligiDegistir(
    KuryeTakipSaglayiciVarligi saglayici, {
    required bool yukari,
  }) async {
    await _kuryeEntegrasyonServisi.saglayiciOnceligiDegistir(
      saglayiciId: saglayici.id,
      yukari: yukari,
    );
    await _kuryeEntegrasyonVerileriniYukle();
  }

  Future<void> _kuryeSaglayicisiTestEt(
    KuryeTakipSaglayiciVarligi saglayici,
  ) async {
    final KuryeSaglayiciTestSonucu sonuc = await _kuryeEntegrasyonServisi
        .baglantiTestEt(saglayici.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(sonuc.mesaj),
        backgroundColor: sonuc.basarili
            ? const Color(0xFF236C57)
            : const Color(0xFF8A2F2F),
      ),
    );
  }

  Future<void> _kuryeEslesmesiniKaydet([
    KuryeCihazEslesmesiVarligi? baslangic,
  ]) async {
    if (_kuryeSaglayicilari.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Once en az bir kurye saglayicisi eklemelisin.'),
        ),
      );
      return;
    }

    final KuryeCihazEslesmesiFormSonucu? sonuc =
        await showDialog<KuryeCihazEslesmesiFormSonucu>(
          context: context,
          builder: (BuildContext context) => KuryeCihazEslesmesiFormDialog(
            saglayicilar: _kuryeSaglayicilari,
            baslangicEslesmesi: baslangic,
          ),
        );
    if (sonuc == null) {
      return;
    }

    await _kuryeEntegrasyonServisi.kuryeCihazEslesmesiKaydet(
      KuryeCihazEslesmesiVarligi(
        kuryeAdi: sonuc.kuryeAdi,
        saglayiciId: sonuc.saglayiciId,
        cihazKimligi: sonuc.cihazKimligi,
        aktifMi: sonuc.aktifMi,
      ),
    );
    await _kuryeEntegrasyonVerileriniYukle();
  }

  Future<void> _kuryeEslesmesiniSil(KuryeCihazEslesmesiVarligi eslesme) async {
    await _kuryeEntegrasyonServisi.kuryeCihazEslesmesiSil(eslesme.kuryeAdi);
    await _kuryeEntegrasyonVerileriniYukle();
  }

  VeriAktarimServisi? _veriAktarimServisiniOlustur() {
    final veritabani = widget.servisKaydi.veritabani;
    if (veritabani == null) {
      return null;
    }
    return VeriAktarimServisi(veritabani);
  }

  Future<void> _menuYedeginiPanoyaKopyala() async {
    final VeriAktarimServisi? veriAktarimServisi =
        _veriAktarimServisiniOlustur();
    if (veriAktarimServisi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yedekleme icin sqlite veri kaynagi gereklidir.'),
        ),
      );
      return;
    }

    setState(() {
      _veriAktarimSuruyor = true;
    });

    try {
      final Map<String, Object?> veri = await veriAktarimServisi
          .menuDisaAktar();
      final String yedekJson = const JsonEncoder.withIndent('  ').convert(veri);
      await Clipboard.setData(ClipboardData(text: yedekJson));
      if (!mounted) {
        return;
      }
      setState(() {
        _sonMenuYedegiJson = yedekJson;
        _veriAktarimDurumu =
            '$_simdiDamgasi menusu panoya yedeklendi. Uzunluk: ${yedekJson.length} karakter.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu yedegi panoya kopyalandi.'),
          backgroundColor: Color(0xFF236C57),
        ),
      );
    } catch (hata) {
      if (!mounted) {
        return;
      }
      setState(() {
        _veriAktarimDurumu = '$_simdiDamgasi yedekleme hatasi: $hata';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yedekleme basarisiz: $hata'),
          backgroundColor: const Color(0xFF8A2F2F),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _veriAktarimSuruyor = false;
        });
      }
    }
  }

  Future<void> _menuYedeginiIceriAktar() async {
    final TextEditingController jsonDenetleyici = TextEditingController(
      text: _sonMenuYedegiJson ?? '',
    );
    bool mevcutVeriyiTemizle = false;
    _MenuYedekAktarimKapsami aktarimKapsami = _MenuYedekAktarimKapsami.tumu;
    final bool? onay = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setD) {
            return AlertDialog(
              title: const Text('Menu yedegini ice aktar'),
              content: SizedBox(
                width: 620,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'JSON metnini yapistir. Istersen mevcut menu kayitlarini temizleyip sifirdan yukleyebilirsin.',
                      style: TextStyle(color: Color(0xFF6D6079)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F5FB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: jsonDenetleyici,
                        minLines: 10,
                        maxLines: 14,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(14),
                          hintText: 'Yedek JSON buraya...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: mevcutVeriyiTemizle,
                      title: const Text('Mevcut menu kayitlarini temizle'),
                      subtitle: const Text(
                        'Aciksa urun/kategori tablolari temizlenip yedekten yuklenir.',
                      ),
                      onChanged: (bool deger) {
                        setD(() {
                          mevcutVeriyiTemizle = deger;
                        });
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 4),
                    _aktarimKapsamiSecici(
                      seciliKapsam: aktarimKapsami,
                      kapsamDegisti: (_MenuYedekAktarimKapsami deger) {
                        setD(() {
                          aktarimKapsami = deger;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Vazgec'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text('Iceri aktar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (onay != true) {
      jsonDenetleyici.dispose();
      return;
    }
    await _menuYedegiMetniniIceriAktar(
      jsonMetni: jsonDenetleyici.text,
      mevcutVeriyiTemizle: mevcutVeriyiTemizle,
      aktarimKapsami: aktarimKapsami,
      kaynakEtiketi: 'manuel JSON',
    );
    jsonDenetleyici.dispose();
  }

  Future<void> _menuYedeginiDosyayaKaydet() async {
    final VeriAktarimServisi? veriAktarimServisi =
        _veriAktarimServisiniOlustur();
    if (veriAktarimServisi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yedekleme icin sqlite veri kaynagi gereklidir.'),
        ),
      );
      return;
    }

    setState(() {
      _veriAktarimSuruyor = true;
    });

    try {
      final Map<String, Object?> veri = await veriAktarimServisi
          .menuDisaAktar();
      final String yedekJson = const JsonEncoder.withIndent('  ').convert(veri);
      final Uint8List bytes = Uint8List.fromList(utf8.encode(yedekJson));
      final String dosyaAdi = _yedekDosyaAdiOlustur();
      final String? kayitYolu = await FilePicker.saveFile(
        dialogTitle: 'Menu yedegini kaydet',
        fileName: dosyaAdi,
        type: FileType.custom,
        allowedExtensions: const <String>['json'],
        bytes: bytes,
      );
      if (!mounted) {
        return;
      }
      if (kayitYolu == null && !kIsWeb) {
        setState(() {
          _veriAktarimDurumu = '$_simdiDamgasi dosya kaydi iptal edildi.';
        });
        return;
      }
      setState(() {
        _sonMenuYedegiJson = yedekJson;
        _veriAktarimDurumu = kayitYolu == null
            ? '$_simdiDamgasi yedek indirme islemi baslatildi. Dosya: $dosyaAdi'
            : '$_simdiDamgasi yedek dosyaya kaydedildi: $kayitYolu';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            kayitYolu == null
                ? 'Yedek indirme baslatildi.'
                : 'Yedek dosyaya kaydedildi.',
          ),
          backgroundColor: const Color(0xFF236C57),
        ),
      );
    } catch (hata) {
      if (!mounted) {
        return;
      }
      setState(() {
        _veriAktarimDurumu = '$_simdiDamgasi dosya kaydetme hatasi: $hata';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dosyaya kaydetme basarisiz: $hata'),
          backgroundColor: const Color(0xFF8A2F2F),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _veriAktarimSuruyor = false;
        });
      }
    }
  }

  Future<void> _menuYedeginiDosyadanYukle() async {
    final FilePickerResult? sonuc = await FilePicker.pickFiles(
      dialogTitle: 'Menu yedek dosyasini sec',
      type: FileType.custom,
      allowedExtensions: const <String>['json'],
      withData: true,
    );
    if (sonuc == null || sonuc.files.isEmpty) {
      return;
    }
    final PlatformFile dosya = sonuc.files.first;
    final Uint8List? bytes = dosya.bytes;
    if (bytes == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Secilen dosyanin icerigi okunamadi.')),
      );
      return;
    }
    if (!mounted) {
      return;
    }

    bool mevcutVeriyiTemizle = false;
    _MenuYedekAktarimKapsami aktarimKapsami = _MenuYedekAktarimKapsami.tumu;
    final bool? onay = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setD) {
            return AlertDialog(
              title: const Text('Dosyadan menu yedegi yukle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dosya: ${dosya.name}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Boyut: ${dosya.size} bayt',
                    style: const TextStyle(color: Color(0xFF6D6079)),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: mevcutVeriyiTemizle,
                    title: const Text('Mevcut menu kayitlarini temizle'),
                    subtitle: const Text(
                      'Aciksa urun/kategori tablolari temizlenip dosyadan yuklenir.',
                    ),
                    onChanged: (bool deger) {
                      setD(() {
                        mevcutVeriyiTemizle = deger;
                      });
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 4),
                  _aktarimKapsamiSecici(
                    seciliKapsam: aktarimKapsami,
                    kapsamDegisti: (_MenuYedekAktarimKapsami deger) {
                      setD(() {
                        aktarimKapsami = deger;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Vazgec'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Yukle'),
                ),
              ],
            );
          },
        );
      },
    );
    if (onay != true) {
      return;
    }

    await _menuYedegiMetniniIceriAktar(
      jsonMetni: utf8.decode(bytes),
      mevcutVeriyiTemizle: mevcutVeriyiTemizle,
      aktarimKapsami: aktarimKapsami,
      kaynakEtiketi: 'dosya ${dosya.name}',
    );
  }

  Future<void> _menuYedegiMetniniIceriAktar({
    required String jsonMetni,
    required bool mevcutVeriyiTemizle,
    required _MenuYedekAktarimKapsami aktarimKapsami,
    required String kaynakEtiketi,
  }) async {
    final VeriAktarimServisi? veriAktarimServisi =
        _veriAktarimServisiniOlustur();
    if (veriAktarimServisi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Iceri aktarim icin sqlite veri kaynagi gereklidir.'),
        ),
      );
      return;
    }

    setState(() {
      _veriAktarimSuruyor = true;
    });
    try {
      final Object? hamJson = jsonDecode(jsonMetni.trim());
      if (hamJson is! Map<String, dynamic>) {
        throw const FormatException('Beklenen yapi JSON nesnesi degil.');
      }
      final Map<String, dynamic> yedekHaritasi = Map<String, dynamic>.from(
        hamJson,
      );
      final (List<String> hatalar, List<String> uyarilar) = _menuYedegiDogrula(
        yedekHaritasi,
        aktarimKapsami,
      );
      if (hatalar.isNotEmpty) {
        final String detay = hatalar.take(3).join(' | ');
        throw FormatException('Yedek dogrulama basarisiz: $detay');
      }
      await veriAktarimServisi.menuIceriAktar(
        yedekHaritasi.cast<String, Object?>(),
        temizle: mevcutVeriyiTemizle,
        kapsami: _servisKapsaminaCevir(aktarimKapsami),
      );
      await _yenile();
      if (!mounted) {
        return;
      }
      setState(() {
        _veriAktarimDurumu =
            '$_simdiDamgasi ${_kapsamEtiketi(aktarimKapsami)} yedegi iceri aktarildi ($kaynakEtiketi).';
        _sonMenuYedegiJson = jsonMetni;
      });
      if (uyarilar.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uyari: ${uyarilar.first}'),
            backgroundColor: const Color(0xFF7C6A1D),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu yedegi iceri aktarildi.'),
          backgroundColor: Color(0xFF236C57),
        ),
      );
    } catch (hata) {
      if (!mounted) {
        return;
      }
      setState(() {
        _veriAktarimDurumu =
            '$_simdiDamgasi iceri aktarim hatasi ($kaynakEtiketi): $hata';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Iceri aktarim basarisiz: $hata'),
          backgroundColor: const Color(0xFF8A2F2F),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _veriAktarimSuruyor = false;
        });
      }
    }
  }

  (List<String> hatalar, List<String> uyarilar) _menuYedegiDogrula(
    Map<String, dynamic> veri,
    _MenuYedekAktarimKapsami aktarimKapsami,
  ) {
    final List<String> hatalar = <String>[];
    final List<String> uyarilar = <String>[];

    final Object? surumHam = veri['surum'];
    if (surumHam is! num) {
      hatalar.add('"surum" alani sayisal olmali.');
    } else if (surumHam.toInt() != 1) {
      hatalar.add('Desteklenmeyen yedek surumu: ${surumHam.toInt()}.');
    }

    final bool kategoriGerekli =
        aktarimKapsami != _MenuYedekAktarimKapsami.sadeceUrunler;
    final bool urunGerekli =
        aktarimKapsami != _MenuYedekAktarimKapsami.sadeceKategoriler;

    final Object? kategoriHam = veri['kategoriler'];
    final Object? urunHam = veri['urunler'];

    if (kategoriHam == null && kategoriGerekli) {
      hatalar.add('"kategoriler" listesi eksik.');
    }
    if (urunHam == null && urunGerekli) {
      hatalar.add('"urunler" listesi eksik.');
    }

    if (kategoriHam != null && kategoriHam is! List<dynamic>) {
      hatalar.add('"kategoriler" alani liste olmali.');
    }
    if (urunHam != null && urunHam is! List<dynamic>) {
      hatalar.add('"urunler" alani liste olmali.');
    }

    final List<dynamic> kategoriler =
        (kategoriHam as List<dynamic>?) ?? <dynamic>[];
    final List<dynamic> urunler = (urunHam as List<dynamic>?) ?? <dynamic>[];

    if (kategoriGerekli && kategoriler.isEmpty) {
      uyarilar.add('Kategori listesi bos.');
    }
    if (urunGerekli && urunler.isEmpty) {
      uyarilar.add('Urun listesi bos.');
    }
    if (aktarimKapsami == _MenuYedekAktarimKapsami.sadeceUrunler) {
      uyarilar.add(
        'Sadece urun aktariminda urunler mevcut kategori kimlikleriyle eslesmelidir.',
      );
    }

    for (int i = 0; i < kategoriler.length && hatalar.length < 12; i++) {
      final dynamic ham = kategoriler[i];
      if (ham is! Map) {
        hatalar.add('kategoriler[$i] nesne formatinda degil.');
        continue;
      }
      final Map<dynamic, dynamic> kayit = ham;
      if (kayit['id'] is! String || (kayit['id'] as String).isEmpty) {
        hatalar.add('kategoriler[$i].id gecersiz.');
      }
      if (kayit['ad'] is! String || (kayit['ad'] as String).trim().isEmpty) {
        hatalar.add('kategoriler[$i].ad gecersiz.');
      }
      if (kayit['sira'] is! num) {
        hatalar.add('kategoriler[$i].sira sayisal olmali.');
      }
      if (kayit['acikMi'] is! bool) {
        hatalar.add('kategoriler[$i].acikMi bool olmali.');
      }
    }

    for (int i = 0; i < urunler.length && hatalar.length < 12; i++) {
      final dynamic ham = urunler[i];
      if (ham is! Map) {
        hatalar.add('urunler[$i] nesne formatinda degil.');
        continue;
      }
      final Map<dynamic, dynamic> kayit = ham;
      if (kayit['id'] is! String || (kayit['id'] as String).isEmpty) {
        hatalar.add('urunler[$i].id gecersiz.');
      }
      if (kayit['kategoriId'] is! String ||
          (kayit['kategoriId'] as String).isEmpty) {
        hatalar.add('urunler[$i].kategoriId gecersiz.');
      }
      if (kayit['ad'] is! String || (kayit['ad'] as String).trim().isEmpty) {
        hatalar.add('urunler[$i].ad gecersiz.');
      }
      if (kayit['aciklama'] is! String) {
        hatalar.add('urunler[$i].aciklama metin olmali.');
      }
      if (kayit['fiyat'] is! num) {
        hatalar.add('urunler[$i].fiyat sayisal olmali.');
      }
      if (kayit['stoktaMi'] is! bool) {
        hatalar.add('urunler[$i].stoktaMi bool olmali.');
      }
      if (kayit['oneCikanMi'] is! bool) {
        hatalar.add('urunler[$i].oneCikanMi bool olmali.');
      }
      if (kayit['seceneklerJson'] is! String) {
        hatalar.add('urunler[$i].seceneklerJson metin olmali.');
      }
    }

    return (hatalar, uyarilar);
  }

  MenuIceriAktarimKapsami _servisKapsaminaCevir(
    _MenuYedekAktarimKapsami aktarimKapsami,
  ) {
    switch (aktarimKapsami) {
      case _MenuYedekAktarimKapsami.tumu:
        return MenuIceriAktarimKapsami.tumu;
      case _MenuYedekAktarimKapsami.sadeceKategoriler:
        return MenuIceriAktarimKapsami.sadeceKategoriler;
      case _MenuYedekAktarimKapsami.sadeceUrunler:
        return MenuIceriAktarimKapsami.sadeceUrunler;
    }
  }

  String _kapsamEtiketi(_MenuYedekAktarimKapsami aktarimKapsami) {
    switch (aktarimKapsami) {
      case _MenuYedekAktarimKapsami.tumu:
        return 'tum menu';
      case _MenuYedekAktarimKapsami.sadeceKategoriler:
        return 'kategori';
      case _MenuYedekAktarimKapsami.sadeceUrunler:
        return 'urun';
    }
  }

  String _aktarimKapsamiAciklama(_MenuYedekAktarimKapsami aktarimKapsami) {
    switch (aktarimKapsami) {
      case _MenuYedekAktarimKapsami.tumu:
        return 'Tum menu (kategori + urun)';
      case _MenuYedekAktarimKapsami.sadeceKategoriler:
        return 'Sadece kategoriler';
      case _MenuYedekAktarimKapsami.sadeceUrunler:
        return 'Sadece urunler';
    }
  }

  Widget _aktarimKapsamiSecici({
    required _MenuYedekAktarimKapsami seciliKapsam,
    required ValueChanged<_MenuYedekAktarimKapsami> kapsamDegisti,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Iceri aktarim kapsami',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<_MenuYedekAktarimKapsami>(
          initialValue: seciliKapsam,
          items: _MenuYedekAktarimKapsami.values
              .map(
                (_MenuYedekAktarimKapsami kapsami) =>
                    DropdownMenuItem<_MenuYedekAktarimKapsami>(
                      value: kapsami,
                      child: Text(_aktarimKapsamiAciklama(kapsami)),
                    ),
              )
              .toList(),
          onChanged: (_MenuYedekAktarimKapsami? deger) {
            if (deger != null) {
              kapsamDegisti(deger);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F5FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  String _yedekDosyaAdiOlustur() {
    final DateTime simdi = DateTime.now();
    final String yil = simdi.year.toString().padLeft(4, '0');
    final String ay = simdi.month.toString().padLeft(2, '0');
    final String gun = simdi.day.toString().padLeft(2, '0');
    final String saat = simdi.hour.toString().padLeft(2, '0');
    final String dakika = simdi.minute.toString().padLeft(2, '0');
    final String saniye = simdi.second.toString().padLeft(2, '0');
    return 'menu_yedegi_${yil}_$ay${gun}_$saat$dakika$saniye.json';
  }

  String get _simdiDamgasi {
    final DateTime simdi = DateTime.now();
    final String saat = simdi.hour.toString().padLeft(2, '0');
    final String dakika = simdi.minute.toString().padLeft(2, '0');
    final String saniye = simdi.second.toString().padLeft(2, '0');
    return '${simdi.year}-${simdi.month.toString().padLeft(2, '0')}-${simdi.day.toString().padLeft(2, '0')} $saat:$dakika:$saniye';
  }

  Widget _yedeklemeIcerigi() {
    final bool sqliteAktif = widget.servisKaydi.veritabani != null;
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF3ECFB), Color(0xFFECEBFF)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cloud_upload_rounded),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Menu yedegi ve geri yukleme',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                sqliteAktif
                    ? 'Ayni panelden menu verisini panoya veya dosyaya disa aktarabilir, JSON ile geri yukleyebilirsin.'
                    : 'Bu ortamda yedekleme pasif. Ozelligi acmak icin sqlite veri kaynagi kullan.',
                style: const TextStyle(color: Color(0xFF6D6079), height: 1.4),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: (!sqliteAktif || _veriAktarimSuruyor)
                        ? null
                        : _menuYedeginiPanoyaKopyala,
                    icon: const Icon(Icons.copy_all_rounded),
                    label: const Text('Yedegi panoya al'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: (!sqliteAktif || _veriAktarimSuruyor)
                        ? null
                        : _menuYedeginiDosyayaKaydet,
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Dosyaya kaydet'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: (!sqliteAktif || _veriAktarimSuruyor)
                        ? null
                        : _menuYedeginiIceriAktar,
                    icon: const Icon(Icons.file_upload_rounded),
                    label: const Text('JSON iceri aktar'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: (!sqliteAktif || _veriAktarimSuruyor)
                        ? null
                        : _menuYedeginiDosyadanYukle,
                    icon: const Icon(Icons.folder_open_rounded),
                    label: const Text('Dosyadan yukle'),
                  ),
                  if (_veriAktarimSuruyor)
                    const Chip(
                      avatar: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      label: Text('Islem suruyor'),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4D8EE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Son islem durumu',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                _veriAktarimDurumu,
                style: const TextStyle(color: Color(0xFF6D6079), height: 1.4),
              ),
            ],
          ),
        ),
        if (_sonMenuYedegiJson != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF201A2B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Son yedek onizleme',
                  style: TextStyle(
                    color: Color(0xFFF5EFFD),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D243B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    _sonMenuYedegiJson!.length > 1400
                        ? '${_sonMenuYedegiJson!.substring(0, 1400)}\n\n...(devami var)'
                        : _sonMenuYedegiJson!,
                    style: const TextStyle(
                      color: Color(0xFFEADCFB),
                      fontFamily: 'monospace',
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _chatbotEntegrasyonKarti() {
    return AyarlarKarti(
      baslik: 'Chatbot entegrasyonu',
      aciklama:
          'Chatbot backend URL ve API anahtarini yonet, baglanti durumunu dogrula.',
      eylem: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          FilledButton.icon(
            onPressed: (_asistanAyarKaydediliyor || _asistanBaglantiTestSuruyor)
                ? null
                : _asistanBackendAyariniKaydet,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Kaydet'),
          ),
          FilledButton.tonalIcon(
            onPressed: (_asistanAyarKaydediliyor || _asistanBaglantiTestSuruyor)
                ? null
                : _asistanBackendBaglantisiniTestEt,
            icon: const Icon(Icons.network_check_rounded),
            label: const Text('Baglanti test et'),
          ),
        ],
      ),
      child: ListView(
        children: <Widget>[
          TextField(
            controller: _asistanBackendUrlDenetleyici,
            decoration: const InputDecoration(
              labelText: 'Backend URL',
              hintText: 'Ornek: https://api.ornek.com',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _asistanApiAnahtariDenetleyici,
            obscureText: !_asistanApiAnahtariGoster,
            decoration: InputDecoration(
              labelText: 'API anahtari',
              hintText: 'Ornek: sk-canli-anahtar',
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: IconButton(
                tooltip: _asistanApiAnahtariGoster
                    ? 'Anahtari gizle'
                    : 'Anahtari goster',
                onPressed: () {
                  setState(() {
                    _asistanApiAnahtariGoster = !_asistanApiAnahtariGoster;
                  });
                },
                icon: Icon(
                  _asistanApiAnahtariGoster
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_asistanAyarKaydediliyor || _asistanBaglantiTestSuruyor)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Chip(
                avatar: SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                label: Text('Islem suruyor'),
              ),
            ),
          Text(
            _asistanBaglantiDurumu,
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
        ],
      ),
    );
  }

  Widget _kuryeEntegrasyonKarti() {
    return AyarlarKarti(
      baslik: 'Kurye entegrasyonu',
      aciklama:
          'Birden fazla GPS saglayicisini yonet, onceliklendir ve kurye cihaz eslesmelerini tanimla.',
      eylem: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          FilledButton.icon(
            onPressed: _kuryeSaglayicisiniKaydet,
            icon: const Icon(Icons.add_link_rounded),
            label: const Text('Saglayici ekle'),
          ),
          FilledButton.tonalIcon(
            onPressed: _kuryeEslesmesiniKaydet,
            icon: const Icon(Icons.perm_device_information_rounded),
            label: const Text('Kurye eslemesi'),
          ),
        ],
      ),
      child: ListView(
        children: <Widget>[
          const Text(
            'Saglayicilar',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (_kuryeSaglayicilari.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Henuz saglayici eklenmedi.',
                style: TextStyle(color: Color(0xFF6D6079)),
              ),
            ),
          ..._kuryeSaglayicilari.asMap().entries.map((
            MapEntry<int, KuryeTakipSaglayiciVarligi> entry,
          ) {
            final int index = entry.key;
            final KuryeTakipSaglayiciVarligi saglayici = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminKuryeSaglayiciSatiri(
                saglayici: saglayici,
                baglantiTestEt: () => _kuryeSaglayicisiTestEt(saglayici),
                duzenle: () => _kuryeSaglayicisiniKaydet(saglayici),
                sil: () => _kuryeSaglayicisiniSil(saglayici),
                aktifYap: () => _kuryeSaglayicisiniAktifYap(saglayici),
                oncelikYukselt: () =>
                    _kuryeSaglayiciOnceligiDegistir(saglayici, yukari: true),
                oncelikDusur: () =>
                    _kuryeSaglayiciOnceligiDegistir(saglayici, yukari: false),
                yukariTasinabilir: index > 0,
                asagiTasinabilir: index < _kuryeSaglayicilari.length - 1,
              ),
            );
          }),
          const SizedBox(height: 10),
          const Text(
            'Kurye-cihaz eslesmeleri',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (_kuryeEslesmeleri.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Henuz kurye eslesmesi tanimlanmadi.',
                style: TextStyle(color: Color(0xFF6D6079)),
              ),
            ),
          ..._kuryeEslesmeleri.map((KuryeCihazEslesmesiVarligi eslesme) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminKuryeEslesmeSatiri(
                eslesme: eslesme,
                saglayiciAdi: _saglayiciAdiBul(eslesme.saglayiciId),
                duzenle: () => _kuryeEslesmesiniKaydet(eslesme),
                sil: () => _kuryeEslesmesiniSil(eslesme),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
                          FilledButton.tonalIcon(
                            onPressed: _chatbotuAc,
                            icon: const Icon(Icons.smart_toy_rounded),
                            label: const Text('Chatbot'),
                          ),
                          const SizedBox(width: 8),
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
                            Tab(text: 'Entegrasyon'),
                            Tab(text: 'Yedekleme'),
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
                            Column(
                              children: <Widget>[
                                Expanded(child: _chatbotEntegrasyonKarti()),
                                const SizedBox(height: 12),
                                Expanded(child: _kuryeEntegrasyonKarti()),
                              ],
                            ),
                            AyarlarKarti(
                              baslik: 'Yedekleme ve veri aktarim',
                              aciklama:
                                  'Menu verisini JSON olarak disa aktar, gerekirse tek adimda geri yukle.',
                              eylem: const SizedBox.shrink(),
                              child: _yedeklemeIcerigi(),
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

  String _saglayiciAdiBul(String saglayiciId) {
    for (final KuryeTakipSaglayiciVarligi saglayici in _kuryeSaglayicilari) {
      if (saglayici.id == saglayiciId) {
        return saglayici.ad;
      }
    }
    return 'Silinmis saglayici';
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
