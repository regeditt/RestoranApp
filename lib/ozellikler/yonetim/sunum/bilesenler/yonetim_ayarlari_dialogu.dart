import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/platform/cihaz_kimligi_saglayici.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ortak/veri/veri_aktarim_servisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_backend_ayar_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/bilesenler/giris_asistani_dialogu.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_asistani_viewmodel.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_karti_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_baglami_cozumleyici.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_pdf_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_filtresi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_formlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_kartlari.dart';
import 'package:url_launcher/url_launcher.dart';

enum _MenuYedekAktarimKapsami { tumu, sadeceKategoriler, sadeceUrunler }

class _OnlineKanalSaglayiciAyari {
  const _OnlineKanalSaglayiciAyari({
    required this.id,
    required this.ad,
    required this.aktifMi,
    required this.webhookYolu,
    required this.secret,
  });

  final String id;
  final String ad;
  final bool aktifMi;
  final String webhookYolu;
  final String secret;

  factory _OnlineKanalSaglayiciAyari.mapten({
    required Map<String, dynamic> kaynak,
    required int index,
  }) {
    final String varsayilanAd = 'Saglayici ${index + 1}';
    final String ad = (kaynak['ad'] is String ? kaynak['ad'] as String : '')
        .trim();
    final String id = (kaynak['id'] is String ? kaynak['id'] as String : '')
        .trim();
    final String webhookYolu =
        (kaynak['webhookYolu'] is String ? kaynak['webhookYolu'] as String : '')
            .trim();
    final String secret =
        (kaynak['secret'] is String ? kaynak['secret'] as String : '').trim();
    final bool aktifMi = kaynak['aktifMi'] is bool
        ? kaynak['aktifMi'] as bool
        : true;
    final String sonAd = ad.isEmpty ? varsayilanAd : ad;
    final String sonId = id.isEmpty ? 'kanal_${index + 1}' : id;
    final String sonWebhookYolu = webhookYolu.isEmpty
        ? '/webhook/${_slugYap(sonAd)}'
        : _webhookYolunuDuzenle(webhookYolu);
    return _OnlineKanalSaglayiciAyari(
      id: sonId,
      ad: sonAd,
      aktifMi: aktifMi,
      webhookYolu: sonWebhookYolu,
      secret: secret,
    );
  }

  Map<String, Object?> mapaDonustur() {
    return <String, Object?>{
      'id': id,
      'ad': ad,
      'aktifMi': aktifMi,
      'webhookYolu': webhookYolu,
      'secret': secret,
    };
  }

  static String _slugYap(String metin) {
    final String normalize = metin.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '-',
    );
    final String slug = normalize.replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.isEmpty ? 'kanal' : slug;
  }

  static String _webhookYolunuDuzenle(String yol) {
    final String temiz = yol.trim();
    if (temiz.isEmpty) {
      return '/webhook/kanal';
    }
    return temiz.startsWith('/') ? temiz : '/$temiz';
  }
}

class _OnlineKanalSaglayiciFormu {
  _OnlineKanalSaglayiciFormu({
    required this.id,
    required String ad,
    required this.aktifMi,
    required String webhookYolu,
    required String secret,
  }) : adDenetleyici = TextEditingController(text: ad),
       webhookYoluDenetleyici = TextEditingController(text: webhookYolu),
       secretDenetleyici = TextEditingController(text: secret);

  final String id;
  final TextEditingController adDenetleyici;
  final TextEditingController webhookYoluDenetleyici;
  final TextEditingController secretDenetleyici;
  bool aktifMi;
  bool secretGoster = false;

  factory _OnlineKanalSaglayiciFormu.ayardan(_OnlineKanalSaglayiciAyari ayar) {
    return _OnlineKanalSaglayiciFormu(
      id: ayar.id,
      ad: ayar.ad,
      aktifMi: ayar.aktifMi,
      webhookYolu: ayar.webhookYolu,
      secret: ayar.secret,
    );
  }

  _OnlineKanalSaglayiciAyari ayaraDonustur() {
    final String ad = adDenetleyici.text.trim().isEmpty
        ? 'Yeni Saglayici'
        : adDenetleyici.text.trim();
    final String webhook = _OnlineKanalSaglayiciAyari._webhookYolunuDuzenle(
      webhookYoluDenetleyici.text.trim().isEmpty
          ? '/webhook/${_OnlineKanalSaglayiciAyari._slugYap(ad)}'
          : webhookYoluDenetleyici.text.trim(),
    );
    return _OnlineKanalSaglayiciAyari(
      id: id,
      ad: ad,
      aktifMi: aktifMi,
      webhookYolu: webhook,
      secret: secretDenetleyici.text.trim(),
    );
  }

  void dispose() {
    adDenetleyici.dispose();
    webhookYoluDenetleyici.dispose();
    secretDenetleyici.dispose();
  }
}

class _OnlineSaglayiciEkleFormSonucu {
  const _OnlineSaglayiciEkleFormSonucu({
    required this.ad,
    required this.webhookYolu,
    required this.secret,
    required this.aktifMi,
  });

  final String ad;
  final String webhookYolu;
  final String secret;
  final bool aktifMi;
}

class _OnlineSaglayiciEkleFormDialog extends StatefulWidget {
  const _OnlineSaglayiciEkleFormDialog({
    required this.baslangicAd,
    required this.baslangicWebhookYolu,
    required this.baslangicAktifMi,
  });

  final String baslangicAd;
  final String baslangicWebhookYolu;
  final bool baslangicAktifMi;

  @override
  State<_OnlineSaglayiciEkleFormDialog> createState() =>
      _OnlineSaglayiciEkleFormDialogState();
}

class _OnlineSaglayiciEkleFormDialogState
    extends State<_OnlineSaglayiciEkleFormDialog> {
  late final TextEditingController _adDenetleyici;
  late final TextEditingController _webhookYoluDenetleyici;
  late final TextEditingController _secretDenetleyici;
  late bool _aktifMi;
  bool _secretGoster = false;

  @override
  void initState() {
    super.initState();
    _adDenetleyici = TextEditingController(text: widget.baslangicAd);
    _webhookYoluDenetleyici = TextEditingController(
      text: widget.baslangicWebhookYolu,
    );
    _secretDenetleyici = TextEditingController();
    _aktifMi = widget.baslangicAktifMi;
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _webhookYoluDenetleyici.dispose();
    _secretDenetleyici.dispose();
    super.dispose();
  }

  String get _onizlemeWebhookYolu {
    final String ad = _adDenetleyici.text.trim();
    final String webhookYolu = _webhookYoluDenetleyici.text.trim();
    final String varsayilanWebhookYolu =
        '/webhook/${_OnlineKanalSaglayiciAyari._slugYap(ad)}';
    return _OnlineKanalSaglayiciAyari._webhookYolunuDuzenle(
      webhookYolu.isEmpty ? varsayilanWebhookYolu : webhookYolu,
    );
  }

  bool get _kaydetAktif => _adDenetleyici.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: const Text('Online saglayici ekle'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _adDenetleyici,
                  decoration: const InputDecoration(
                    labelText: 'Saglayici adi',
                    hintText: 'Ornek: Uber Eats',
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _webhookYoluDenetleyici,
                  decoration: const InputDecoration(
                    labelText: 'Webhook yolu',
                    hintText: '/webhook/ornek',
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Onizleme: $_onizlemeWebhookYolu',
                    style: const TextStyle(color: Color(0xFF6D6079)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _secretDenetleyici,
                  obscureText: !_secretGoster,
                  decoration: InputDecoration(
                    labelText: 'Webhook secret',
                    hintText: 'Imza dogrulama anahtari',
                    suffixIcon: IconButton(
                      tooltip: _secretGoster ? 'Secret gizle' : 'Secret goster',
                      onPressed: () {
                        setState(() {
                          _secretGoster = !_secretGoster;
                        });
                      },
                      icon: Icon(
                        _secretGoster ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aktif olarak baslat'),
                  value: _aktifMi,
                  onChanged: (bool deger) {
                    setState(() {
                      _aktifMi = deger;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: !_kaydetAktif
                ? null
                : () {
                    Navigator.of(context).pop(
                      _OnlineSaglayiciEkleFormSonucu(
                        ad: _adDenetleyici.text.trim(),
                        webhookYolu: _onizlemeWebhookYolu,
                        secret: _secretDenetleyici.text.trim(),
                        aktifMi: _aktifMi,
                      ),
                    );
                  },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class _OnlineSiparisEntegrasyonAyari {
  const _OnlineSiparisEntegrasyonAyari({
    required this.gatewayUrl,
    required this.saglayicilar,
  });

  static const String varsayilanGatewayUrl = 'http://127.0.0.1:8787';

  final String gatewayUrl;
  final List<_OnlineKanalSaglayiciAyari> saglayicilar;

  factory _OnlineSiparisEntegrasyonAyari.varsayilan() {
    return _OnlineSiparisEntegrasyonAyari(
      gatewayUrl: varsayilanGatewayUrl,
      saglayicilar: <_OnlineKanalSaglayiciAyari>[
        const _OnlineKanalSaglayiciAyari(
          id: 'yemeksepeti',
          ad: 'Yemeksepeti',
          aktifMi: true,
          webhookYolu: '/webhook/yemeksepeti',
          secret: '',
        ),
        const _OnlineKanalSaglayiciAyari(
          id: 'getir',
          ad: 'Getir',
          aktifMi: true,
          webhookYolu: '/webhook/getir',
          secret: '',
        ),
        const _OnlineKanalSaglayiciAyari(
          id: 'trendyol',
          ad: 'Trendyol',
          aktifMi: true,
          webhookYolu: '/webhook/trendyol',
          secret: '',
        ),
      ],
    );
  }

  factory _OnlineSiparisEntegrasyonAyari.jsondan(String jsonMetni) {
    final Object? ham = jsonDecode(jsonMetni);
    if (ham is! Map<String, dynamic>) {
      throw const FormatException('Online siparis ayari formati gecersiz.');
    }
    final _OnlineSiparisEntegrasyonAyari varsayilan =
        _OnlineSiparisEntegrasyonAyari.varsayilan();
    final List<_OnlineKanalSaglayiciAyari> saglayicilar = _saglayicilariCoz(
      ham,
      varsayilan.saglayicilar,
    );
    return _OnlineSiparisEntegrasyonAyari(
      gatewayUrl: _stringDeger(ham, 'gatewayUrl', varsayilan.gatewayUrl).trim(),
      saglayicilar: saglayicilar,
    );
  }

  static List<_OnlineKanalSaglayiciAyari> _saglayicilariCoz(
    Map<String, dynamic> ham,
    List<_OnlineKanalSaglayiciAyari> varsayilanlar,
  ) {
    final Object? hamSaglayicilar = ham['saglayicilar'];
    if (hamSaglayicilar is List) {
      final List<_OnlineKanalSaglayiciAyari> sonuc =
          <_OnlineKanalSaglayiciAyari>[];
      for (int i = 0; i < hamSaglayicilar.length; i++) {
        final Object? oge = hamSaglayicilar[i];
        if (oge is! Map<String, dynamic>) {
          continue;
        }
        sonuc.add(_OnlineKanalSaglayiciAyari.mapten(kaynak: oge, index: i));
      }
      if (sonuc.isNotEmpty) {
        return sonuc;
      }
    }
    return <_OnlineKanalSaglayiciAyari>[
      _OnlineKanalSaglayiciAyari(
        id: varsayilanlar[0].id,
        ad: varsayilanlar[0].ad,
        aktifMi: _boolDeger(ham, 'yemeksepetiAktif', varsayilanlar[0].aktifMi),
        webhookYolu: _OnlineKanalSaglayiciAyari._webhookYolunuDuzenle(
          _stringDeger(
            ham,
            'yemeksepetiWebhookYolu',
            varsayilanlar[0].webhookYolu,
          ).trim(),
        ),
        secret: _stringDeger(
          ham,
          'yemeksepetiSecret',
          varsayilanlar[0].secret,
        ).trim(),
      ),
      _OnlineKanalSaglayiciAyari(
        id: varsayilanlar[1].id,
        ad: varsayilanlar[1].ad,
        aktifMi: _boolDeger(ham, 'getirAktif', varsayilanlar[1].aktifMi),
        webhookYolu: _OnlineKanalSaglayiciAyari._webhookYolunuDuzenle(
          _stringDeger(
            ham,
            'getirWebhookYolu',
            varsayilanlar[1].webhookYolu,
          ).trim(),
        ),
        secret: _stringDeger(
          ham,
          'getirSecret',
          varsayilanlar[1].secret,
        ).trim(),
      ),
      _OnlineKanalSaglayiciAyari(
        id: varsayilanlar[2].id,
        ad: varsayilanlar[2].ad,
        aktifMi: _boolDeger(ham, 'trendyolAktif', varsayilanlar[2].aktifMi),
        webhookYolu: _OnlineKanalSaglayiciAyari._webhookYolunuDuzenle(
          _stringDeger(
            ham,
            'trendyolWebhookYolu',
            varsayilanlar[2].webhookYolu,
          ).trim(),
        ),
        secret: _stringDeger(
          ham,
          'trendyolSecret',
          varsayilanlar[2].secret,
        ).trim(),
      ),
    ];
  }

  static String _stringDeger(
    Map<String, dynamic> kaynak,
    String anahtar,
    String varsayilan,
  ) {
    final Object? deger = kaynak[anahtar];
    return deger is String ? deger : varsayilan;
  }

  static bool _boolDeger(
    Map<String, dynamic> kaynak,
    String anahtar,
    bool varsayilan,
  ) {
    final Object? deger = kaynak[anahtar];
    return deger is bool ? deger : varsayilan;
  }

  String jsonaDonustur() {
    return jsonEncode(<String, Object?>{
      'gatewayUrl': gatewayUrl,
      'saglayicilar': saglayicilar
          .map((saglayici) => saglayici.mapaDonustur())
          .toList(growable: false),
    });
  }
}

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
  late final LisansAnahtariDogrulayici _lisansDogrulayici;

  late List<SalonBolumuVarligi> _salonBolumleri;
  late List<KategoriVarligi> _menuKategorileri;
  late List<UrunVarligi> _menuUrunleri;
  List<HammaddeStokVarligi> _hammaddeler = const <HammaddeStokVarligi>[];
  List<HammaddeStokVarligi> _stokEkraniHammaddeleri =
      const <HammaddeStokVarligi>[];
  StokUyariFiltresi _seciliStokFiltresi = StokUyariFiltresi.tum;
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
  static const String _onlineSiparisAyarAnahtari =
      'online_siparis_entegrasyon_v1';
  final TextEditingController _onlineGatewayUrlDenetleyici =
      TextEditingController();
  List<_OnlineKanalSaglayiciFormu> _onlineSaglayiciFormlari =
      <_OnlineKanalSaglayiciFormu>[];
  bool _onlineAyarKaydediliyor = false;
  bool _onlineBaglantiTestSuruyor = false;
  String _onlineDurumMesaji = 'Online siparis entegrasyon ayarlari yukleniyor.';
  final TextEditingController _lisansCihazKoduDenetleyici =
      TextEditingController();
  DateTime _lisansGecerlilikTarihi = DateTime.now().add(
    const Duration(days: 365),
  );
  String _uretilenLisansAnahtari = '';
  String _lisansUretimDurumu =
      'Cihaz kodunu gir, gecerlilik tarihini sec ve lisansi uret.';
  static const bool _dagiticiModuAktif = UygulamaSabitleri.dagiticiModu;

  @override
  void initState() {
    super.initState();
    _kuryeEntegrasyonServisi =
        widget.servisKaydi.kuryeEntegrasyonYonetimServisi;
    _lisansDogrulayici = const LisansAnahtariDogrulayici();
    _lisansCihazKoduDenetleyici.text = cihazKimligiSaglayici.cihazKoduGetir();
    _salonBolumleri = widget.salonBolumleri;
    _menuKategorileri = widget.menuKategorileri;
    _menuUrunleri = widget.menuUrunleri;
    _stokVerileriniYukle();
    _kuryeEntegrasyonVerileriniYukle();
    _asistanBackendAyariniYukle();
    _onlineSiparisEntegrasyonAyariniYukle();
  }

  @override
  void dispose() {
    _asistanBackendUrlDenetleyici.dispose();
    _asistanApiAnahtariDenetleyici.dispose();
    _onlineGatewayUrlDenetleyici.dispose();
    _onlineSaglayiciFormlariniTemizle();
    _lisansCihazKoduDenetleyici.dispose();
    super.dispose();
  }

  Future<void> _stokVerileriniYukle() async {
    final List<HammaddeStokVarligi> hammaddeler = await widget.servisKaydi
        .hammaddeleriGetirUseCase();
    final List<HammaddeStokVarligi> stokEkraniHammaddeleri = await widget
        .servisKaydi
        .hammaddeleriUyariyaGoreGetirUseCase(filtre: _seciliStokFiltresi);
    final Map<String, List<ReceteKalemiVarligi>> urunReceteleri =
        await _urunReceteleriniYukle(_menuUrunleri);
    if (!mounted) {
      return;
    }
    setState(() {
      _hammaddeler = hammaddeler;
      _stokEkraniHammaddeleri = stokEkraniHammaddeleri;
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

  Future<void> _onlineSiparisEntegrasyonAyariniYukle() async {
    final _OnlineSiparisEntegrasyonAyari varsayilanAyar =
        _OnlineSiparisEntegrasyonAyari.varsayilan();
    final bool sqliteAktif = widget.servisKaydi.veritabani != null;
    _OnlineSiparisEntegrasyonAyari ayar = varsayilanAyar;
    String durumMesaji = sqliteAktif
        ? 'Kayitli online siparis ayarlari yuklendi.'
        : 'SQLite kapali oldugu icin online siparis ayarlari sadece bu oturumda kalir.';
    if (sqliteAktif) {
      try {
        final String? jsonAyar = await widget.servisKaydi.veritabani!.ayarOku(
          _onlineSiparisAyarAnahtari,
        );
        if (jsonAyar == null || jsonAyar.trim().isEmpty) {
          durumMesaji =
              'Kayitli ayar bulunamadi. Varsayilan degerler yuklendi.';
        } else {
          ayar = _OnlineSiparisEntegrasyonAyari.jsondan(jsonAyar);
        }
      } catch (_) {
        ayar = varsayilanAyar;
        durumMesaji =
            'Kayitli ayarlar okunamadi. Varsayilan degerlerle devam ediliyor.';
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _onlineGatewayUrlDenetleyici.text = ayar.gatewayUrl;
      _onlineSaglayiciFormlariniTemizle();
      _onlineSaglayiciFormlari = ayar.saglayicilar
          .map(_OnlineKanalSaglayiciFormu.ayardan)
          .toList();
      _onlineDurumMesaji = durumMesaji;
    });
  }

  void _onlineSaglayiciFormlariniTemizle() {
    for (final _OnlineKanalSaglayiciFormu form in _onlineSaglayiciFormlari) {
      form.dispose();
    }
    _onlineSaglayiciFormlari = <_OnlineKanalSaglayiciFormu>[];
  }

  _OnlineKanalSaglayiciFormu _onlineYeniSaglayiciFormu({
    String? ad,
    bool? aktifMi,
    String? webhookYolu,
    String? secret,
  }) {
    final int sira = _onlineSaglayiciFormlari.length + 1;
    final String sonAd = (ad ?? '').trim().isEmpty
        ? 'Yeni Saglayici $sira'
        : ad!.trim();
    final String sonWebhookYolu =
        _OnlineKanalSaglayiciAyari._webhookYolunuDuzenle(
          (webhookYolu ?? '').trim().isEmpty
              ? '/webhook/${_OnlineKanalSaglayiciAyari._slugYap(sonAd)}'
              : webhookYolu!.trim(),
        );
    return _OnlineKanalSaglayiciFormu(
      id: 'kanal_${DateTime.now().microsecondsSinceEpoch}',
      ad: sonAd,
      aktifMi: aktifMi ?? true,
      webhookYolu: sonWebhookYolu,
      secret: secret?.trim() ?? '',
    );
  }

  Future<void> _onlineSaglayiciEkle() async {
    final int sira = _onlineSaglayiciFormlari.length + 1;
    final String varsayilanAd = 'Yeni Saglayici $sira';
    final _OnlineSaglayiciEkleFormSonucu? sonuc =
        await showDialog<_OnlineSaglayiciEkleFormSonucu>(
          context: context,
          builder: (BuildContext context) => _OnlineSaglayiciEkleFormDialog(
            baslangicAd: varsayilanAd,
            baslangicWebhookYolu:
                '/webhook/${_OnlineKanalSaglayiciAyari._slugYap(varsayilanAd)}',
            baslangicAktifMi: true,
          ),
        );
    if (sonuc == null || !mounted) {
      return;
    }
    setState(() {
      _onlineSaglayiciFormlari = <_OnlineKanalSaglayiciFormu>[
        ..._onlineSaglayiciFormlari,
        _onlineYeniSaglayiciFormu(
          ad: sonuc.ad,
          aktifMi: sonuc.aktifMi,
          webhookYolu: sonuc.webhookYolu,
          secret: sonuc.secret,
        ),
      ];
    });
  }

  void _onlineSaglayiciSil(_OnlineKanalSaglayiciFormu form) {
    setState(() {
      _onlineSaglayiciFormlari = _onlineSaglayiciFormlari
          .where((mevcut) => mevcut.id != form.id)
          .toList();
      form.dispose();
    });
  }

  _OnlineSiparisEntegrasyonAyari _onlineAyarModeliniOlustur() {
    return _OnlineSiparisEntegrasyonAyari(
      gatewayUrl: _onlineGatewayUrlDenetleyici.text.trim(),
      saglayicilar: _onlineSaglayiciFormlari
          .map((form) => form.ayaraDonustur())
          .toList(growable: false),
    );
  }

  Future<void> _onlineSiparisEntegrasyonAyariniKaydet() async {
    if (_onlineSaglayiciFormlari.isEmpty) {
      setState(() {
        _onlineDurumMesaji =
            'Kaydetmeden once en az bir online saglayici eklemelisin.';
      });
      return;
    }
    final bool sqliteAktif = widget.servisKaydi.veritabani != null;
    if (!sqliteAktif) {
      setState(() {
        _onlineDurumMesaji =
            'SQLite kapali oldugu icin ayarlar kalici saklanamadi.';
      });
      return;
    }
    setState(() {
      _onlineAyarKaydediliyor = true;
      _onlineDurumMesaji = 'Ayarlar kaydediliyor...';
    });
    bool kayitBasarili = true;
    try {
      final _OnlineSiparisEntegrasyonAyari ayar = _onlineAyarModeliniOlustur();
      await widget.servisKaydi.veritabani!.ayarYaz(
        _onlineSiparisAyarAnahtari,
        ayar.jsonaDonustur(),
      );
    } catch (_) {
      kayitBasarili = false;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _onlineAyarKaydediliyor = false;
      _onlineDurumMesaji = kayitBasarili
          ? 'Online siparis entegrasyon ayarlari kaydedildi.'
          : 'Kaydetme sirasinda hata olustu. Tekrar deneyebilirsin.';
    });
  }

  Future<void> _onlineSiparisGatewayBaglantisiniTestEt() async {
    final String tabanUrl = _onlineGatewayUrlDenetleyici.text.trim();
    final Uri? url = Uri.tryParse(tabanUrl);
    if (tabanUrl.isEmpty ||
        url == null ||
        !url.hasScheme ||
        url.host.trim().isEmpty) {
      setState(() {
        _onlineDurumMesaji =
            'Gateway URL gecersiz. Ornek: http://127.0.0.1:8787';
      });
      return;
    }
    setState(() {
      _onlineBaglantiTestSuruyor = true;
      _onlineDurumMesaji = 'Gateway baglantisi test ediliyor...';
    });
    String durumMesaji;
    try {
      final Uri saglikUrl = url.resolve('/health');
      final http.Response yanit = await http
          .get(saglikUrl)
          .timeout(const Duration(seconds: 7));
      durumMesaji = yanit.statusCode == 200
          ? 'Gateway baglantisi basarili: ${saglikUrl.toString()}'
          : 'Gateway yaniti alindi fakat durum kodu ${yanit.statusCode}.';
    } catch (_) {
      durumMesaji =
          'Gateway baglantisi basarisiz. Adresi ve gateway servisinin calistigini kontrol et.';
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _onlineBaglantiTestSuruyor = false;
      _onlineDurumMesaji = durumMesaji;
    });
  }

  String _onlineWebhookTamAdresi(String webhookYolu) {
    final String tabanUrl = _onlineGatewayUrlDenetleyici.text.trim();
    if (tabanUrl.isEmpty) {
      return webhookYolu;
    }
    final Uri? url = Uri.tryParse(tabanUrl);
    if (url == null || !url.hasScheme || url.host.trim().isEmpty) {
      return '$tabanUrl${webhookYolu.startsWith('/') ? '' : '/'}$webhookYolu';
    }
    final String normalizedPath = webhookYolu.startsWith('/')
        ? webhookYolu
        : '/$webhookYolu';
    return url.resolve(normalizedPath).toString();
  }

  Future<void> _onlineWebhookAdresleriniKopyala() async {
    if (_onlineSaglayiciFormlari.isEmpty) {
      setState(() {
        _onlineDurumMesaji =
            'Kopyalamak icin once en az bir online saglayici eklemelisin.';
      });
      return;
    }
    final List<String> satirlar = _onlineSaglayiciFormlari.map((form) {
      final String ad = form.adDenetleyici.text.trim().isEmpty
          ? 'Saglayici'
          : form.adDenetleyici.text.trim();
      final String webhookYolu = form.webhookYoluDenetleyici.text.trim();
      return '$ad: ${_onlineWebhookTamAdresi(webhookYolu)}';
    }).toList();
    final String metin = satirlar.join('\n');
    await Clipboard.setData(ClipboardData(text: metin));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Webhook adresleri kopyalandi.')),
    );
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
    final List<HammaddeStokVarligi> stokEkraniHammaddeleri = await widget
        .servisKaydi
        .hammaddeleriUyariyaGoreGetirUseCase(filtre: _seciliStokFiltresi);
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
      _stokEkraniHammaddeleri = stokEkraniHammaddeleri;
      _urunReceteleri = urunReceteleri;
      _kuryeSaglayicilari = saglayicilar;
      _kuryeEslesmeleri = eslesmeler;
    });
  }

  Future<void> _stokFiltresiSec(StokUyariFiltresi filtre) async {
    if (_seciliStokFiltresi == filtre) {
      return;
    }
    setState(() {
      _seciliStokFiltresi = filtre;
    });
    final List<HammaddeStokVarligi> stokEkraniHammaddeleri = await widget
        .servisKaydi
        .hammaddeleriUyariyaGoreGetirUseCase(filtre: filtre);
    if (!mounted) {
      return;
    }
    setState(() {
      _stokEkraniHammaddeleri = stokEkraniHammaddeleri;
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
    final bool yetkili = await _yetkiyiDogrula(
      IslemYetkisi.stokYonetimi,
      hataMesaji: 'Stok yonetimi yetkin bulunmuyor.',
    );
    if (!yetkili) {
      return;
    }
    if (!mounted) {
      return;
    }
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
        uyariEsigi: sonuc.uyariEsigi,
        kritikEsik: sonuc.kritikEsik,
        birimMaliyet: sonuc.birimMaliyet,
      ),
    );
    await _yenile();
  }

  Future<void> _hammaddeDuzenle(HammaddeStokVarligi hammadde) async {
    final bool yetkili = await _yetkiyiDogrula(
      IslemYetkisi.stokYonetimi,
      hataMesaji: 'Stok duzenleme yetkin bulunmuyor.',
    );
    if (!yetkili) {
      return;
    }
    if (!mounted) {
      return;
    }
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
        uyariEsigi: sonuc.uyariEsigi,
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
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _asistanApiAnahtariDenetleyici,
            obscureText: !_asistanApiAnahtariGoster,
            decoration: InputDecoration(
              labelText: 'API anahtari',
              hintText: 'Ornek: sk-canli-anahtar',
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
          const SizedBox(height: 12),
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

  Widget _onlineKanalAyarKarti({
    required _OnlineKanalSaglayiciFormu form,
    required VoidCallback saglayiciSil,
  }) {
    final String baslik = form.adDenetleyici.text.trim().isEmpty
        ? 'Yeni saglayici'
        : form.adDenetleyici.text.trim();
    final String webhookBaslikDegeri = _onlineWebhookTamAdresi(
      form.webhookYoluDenetleyici.text.trim(),
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: form.aktifMi
              ? const Color(0xFFB9F2DC)
              : const Color(0xFFE8E0F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      baslik,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Webhook siparis saglayici ayari',
                      style: TextStyle(color: Color(0xFF6D6079)),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: form.aktifMi,
                onChanged: (bool deger) {
                  setState(() {
                    form.aktifMi = deger;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: form.adDenetleyici,
            decoration: const InputDecoration(
              labelText: 'Saglayici adi',
              hintText: 'Ornek: UberEats',
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: form.webhookYoluDenetleyici,
            decoration: const InputDecoration(
              labelText: 'Webhook yolu',
              hintText: '/webhook/ornek',
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Tam adres: $webhookBaslikDegeri',
            style: const TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: form.secretDenetleyici,
            obscureText: !form.secretGoster,
            decoration: InputDecoration(
              labelText: 'Webhook secret',
              hintText: 'Imza dogrulama anahtari',
              suffixIcon: IconButton(
                tooltip: form.secretGoster ? 'Secret gizle' : 'Secret goster',
                onPressed: () {
                  setState(() {
                    form.secretGoster = !form.secretGoster;
                  });
                },
                icon: Icon(
                  form.secretGoster ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: saglayiciSil,
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Saglayiciyi sil'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _onlineSiparisEntegrasyonKarti() {
    return AyarlarKarti(
      baslik: 'Online siparis entegrasyonlari',
      aciklama:
          'Saglayicilari dinamik ekle/sil; yarin yeni bir platform geldiginde kod degistirmeden ekleyebil.',
      eylem: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          FilledButton.icon(
            onPressed: (_onlineAyarKaydediliyor || _onlineBaglantiTestSuruyor)
                ? null
                : _onlineSiparisEntegrasyonAyariniKaydet,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Kaydet'),
          ),
          FilledButton.tonalIcon(
            onPressed: (_onlineAyarKaydediliyor || _onlineBaglantiTestSuruyor)
                ? null
                : _onlineSiparisGatewayBaglantisiniTestEt,
            icon: const Icon(Icons.network_check_rounded),
            label: const Text('Gateway test et'),
          ),
          FilledButton.tonalIcon(
            onPressed: (_onlineAyarKaydediliyor || _onlineBaglantiTestSuruyor)
                ? null
                : _onlineSaglayiciEkle,
            icon: const Icon(Icons.add_link_rounded),
            label: const Text('Saglayici ekle'),
          ),
          FilledButton.tonalIcon(
            onPressed: _onlineWebhookAdresleriniKopyala,
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Webhook adresleri'),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: <Widget>[
          TextField(
            controller: _onlineGatewayUrlDenetleyici,
            decoration: const InputDecoration(
              labelText: 'Gateway URL',
              hintText: 'Ornek: http://127.0.0.1:8787',
            ),
          ),
          const SizedBox(height: 12),
          if (_onlineSaglayiciFormlari.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Henuz saglayici eklenmedi. "Saglayici ekle" ile yeni kanal olustur.',
                style: TextStyle(color: Color(0xFF6D6079)),
              ),
            ),
          ..._onlineSaglayiciFormlari.map((form) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _onlineKanalAyarKarti(
                form: form,
                saglayiciSil: () => _onlineSaglayiciSil(form),
              ),
            );
          }),
          const SizedBox(height: 12),
          if (_onlineAyarKaydediliyor || _onlineBaglantiTestSuruyor)
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
            _onlineDurumMesaji,
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Not: Webhook imza dogrulamasi icin her platformun secret degerini gateway ile ayni tutmalisin.',
            style: TextStyle(color: Color(0xFF6D6079), height: 1.4),
          ),
        ],
      ),
    );
  }

  Future<void> _lisansGecerlilikTarihiSec() async {
    final DateTime simdi = DateTime.now();
    final DateTime? secilen = await showDatePicker(
      context: context,
      initialDate: _lisansGecerlilikTarihi.isBefore(simdi)
          ? simdi
          : _lisansGecerlilikTarihi,
      firstDate: DateTime(simdi.year - 1, 1, 1),
      lastDate: DateTime(simdi.year + 10, 12, 31),
    );
    if (secilen == null || !mounted) {
      return;
    }
    setState(() {
      _lisansGecerlilikTarihi = secilen;
    });
  }

  void _lisansAnahtariUret() {
    final String cihazKodu = _lisansDogrulayici.cihazKoduDuzenle(
      _lisansCihazKoduDenetleyici.text,
    );
    try {
      final String lisansAnahtari = _lisansDogrulayici.lisansAnahtariOlustur(
        _lisansGecerlilikTarihi,
        cihazKodu: cihazKodu,
      );
      setState(() {
        _lisansCihazKoduDenetleyici.text = cihazKodu;
        _uretilenLisansAnahtari = lisansAnahtari;
        _lisansUretimDurumu = 'Lisans anahtari hazir.';
      });
    } on ArgumentError catch (hata) {
      setState(() {
        _uretilenLisansAnahtari = '';
        _lisansUretimDurumu = '${hata.message}';
      });
    }
  }

  Future<void> _lisansAnahtariniKopyala() async {
    if (_uretilenLisansAnahtari.trim().isEmpty) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: _uretilenLisansAnahtari));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lisans anahtari kopyalandi.')),
    );
  }

  Widget _lisansSekmesiIcerigi() {
    return AyarlarKarti(
      baslik: 'Lisans uretim paneli',
      aciklama:
          'Musteriden gelen cihaz kodu ve gecerlilik tarihiyle lisans anahtari uret.',
      eylem: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          FilledButton.icon(
            onPressed: _lisansAnahtariUret,
            icon: const Icon(Icons.key_rounded),
            label: const Text('Lisans uret'),
          ),
          FilledButton.tonalIcon(
            onPressed: _lisansGecerlilikTarihiSec,
            icon: const Icon(Icons.event_rounded),
            label: const Text('Tarih sec'),
          ),
          FilledButton.tonalIcon(
            onPressed: () {
              setState(() {
                _lisansCihazKoduDenetleyici.text = cihazKimligiSaglayici
                    .cihazKoduGetir();
              });
            },
            icon: const Icon(Icons.computer_rounded),
            label: const Text('Bu cihaz kodu'),
          ),
          if (_uretilenLisansAnahtari.isNotEmpty)
            FilledButton.tonalIcon(
              onPressed: _lisansAnahtariniKopyala,
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Anahtari kopyala'),
            ),
        ],
      ),
      child: ListView(
        children: <Widget>[
          TextField(
            controller: _lisansCihazKoduDenetleyici,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Cihaz kodu',
              hintText: 'Ornek: A1B2C3',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4D8EE)),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.calendar_month_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Gecerlilik: ${_tarihiEtiketle(_lisansGecerlilikTarihi)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFBFE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4D8EE)),
            ),
            child: SelectableText(
              _uretilenLisansAnahtari.isEmpty
                  ? 'Uretilen lisans anahtari burada gorunur.'
                  : _uretilenLisansAnahtari,
              style: TextStyle(
                color: _uretilenLisansAnahtari.isEmpty
                    ? const Color(0xFF8C7A99)
                    : const Color(0xFF22162C),
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _lisansUretimDurumu,
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Not: Musteri lisans ekranindan cihaz kodunu kopyalayip sana iletmeli. '
            'Anahtar formati VP-YYYYMMDD-CCCCCC-XXXXXX olacak.',
            style: TextStyle(color: Color(0xFF6D6079), height: 1.4),
          ),
        ],
      ),
    );
  }

  String _tarihiEtiketle(DateTime tarih) {
    return '${tarih.year.toString().padLeft(4, '0')}-'
        '${tarih.month.toString().padLeft(2, '0')}-'
        '${tarih.day.toString().padLeft(2, '0')}';
  }

  Widget _entegrasyonSekmesiIcerigi() {
    const Color altSekmeArkaPlanRengi = Color(0xFFF4EEF8);
    final Color altSekmeKontrastRengi =
        AnaSayfaRenkSablonu.kontrastliMetinRengi(altSekmeArkaPlanRengi);
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: altSekmeArkaPlanRengi,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              labelColor: AnaSayfaRenkSablonu.birincilAksiyon,
              unselectedLabelColor: altSekmeKontrastRengi.withValues(
                alpha: 0.82,
              ),
              indicatorColor: AnaSayfaRenkSablonu.birincilAksiyon,
              tabs: const <Widget>[
                Tab(text: 'Chatbox'),
                Tab(text: 'Kurye'),
                Tab(text: 'Online Siparis'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                _chatbotEntegrasyonKarti(),
                _kuryeEntegrasyonKarti(),
                _onlineSiparisEntegrasyonKarti(),
              ],
            ),
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
    const Color sekmeArkaPlanRengi = Color(0xFFF4EEF8);
    final Color sekmeKontrastRengi = AnaSayfaRenkSablonu.kontrastliMetinRengi(
      sekmeArkaPlanRengi,
    );
    final ThemeData temelTema = Theme.of(context);
    const Color ayarlarInputDolguRengi = Color(0xFFFAF8FD);
    const Color ayarlarInputKenarRengi = Color(0xFFD7CBE5);
    final ThemeData ayarlarTema = temelTema.copyWith(
      colorScheme: temelTema.colorScheme.copyWith(
        surface: const Color(0xFFF8F5FB),
        onSurface: AnaSayfaRenkSablonu.metinAcikZemin,
        primary: AnaSayfaRenkSablonu.birincilAksiyon,
      ),
      textTheme: temelTema.textTheme.apply(
        bodyColor: AnaSayfaRenkSablonu.metinAcikZemin,
        displayColor: AnaSayfaRenkSablonu.metinAcikZemin,
      ),
      iconTheme: const IconThemeData(color: AnaSayfaRenkSablonu.metinAcikZemin),
      inputDecorationTheme: temelTema.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: ayarlarInputDolguRengi,
        labelStyle: const TextStyle(
          color: Color(0xFF615074),
          fontWeight: FontWeight.w700,
        ),
        floatingLabelStyle: const TextStyle(
          color: AnaSayfaRenkSablonu.birincilAksiyon,
          fontWeight: FontWeight.w800,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF8B7A9D),
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: const Color(0xFF7B6B8F),
        suffixIconColor: const Color(0xFF7B6B8F),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: ayarlarInputKenarRengi),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: ayarlarInputKenarRengi),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: AnaSayfaRenkSablonu.birincilAksiyon,
            width: 1.8,
          ),
        ),
      ),
    );

    final List<Widget> ustSekmeler = <Widget>[
      const Tab(text: 'Salon'),
      const Tab(text: 'Menu'),
      const Tab(text: 'Stok'),
      const Tab(text: 'Entegrasyon'),
      const Tab(text: 'Yedekleme'),
      if (_dagiticiModuAktif) const Tab(text: 'Lisans'),
    ];
    final List<Widget> sekmeIcerikleri = <Widget>[
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
              icon: const Icon(Icons.add_business_rounded),
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
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AdminBolumKarti(
                    bolum: bolum,
                    masaEkle: () => _masaEkle(bolum),
                    bolumDuzenle: () => _bolumDuzenle(bolum),
                    bolumSil: () => _bolumSil(bolum),
                    qrBaglamiAc: (MasaTanimiVarligi masa) =>
                        _masaQrBaglamiAc(bolum, masa),
                    masaDuzenle: (MasaTanimiVarligi masa) =>
                        _masaDuzenle(bolum, masa),
                    masaSil: (MasaTanimiVarligi masa) => _masaSil(bolum, masa),
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
              icon: const Icon(Icons.restaurant_menu_rounded),
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
                    (KategoriVarligi kategori) => InputChip(
                      label: Text(kategori.ad),
                      onPressed: () => _kategoriDuzenle(kategori),
                      onDeleted: () => _kategoriSil(kategori),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            ..._menuUrunleri.map(
              (UrunVarligi urun) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AdminUrunSatiri(
                  urun: urun,
                  kategoriAdi: _kategoriAdiBul(urun.kategoriId),
                  receteOzeti: _receteOzetiniOlustur(urun.id),
                  urunDuzenle: () => _urunEkle(urun),
                  receteDuzenle: () => _urunRecetesiniDuzenle(urun),
                  urunSil: () => _urunSil(urun),
                ),
              ),
            ),
          ],
        ),
      ),
      AyarlarKarti(
        baslik: 'Stok girisi',
        aciklama: 'Hammadde ekle ve kritik seviyeye yaklasan kalemleri izle.',
        eylem: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: _hammaddeEkle,
              icon: const Icon(Icons.inventory_2_rounded),
              label: const Text('Hammadde ekle'),
            ),
            ...StokUyariFiltresi.values.map(
              (StokUyariFiltresi filtre) => ChoiceChip(
                label: Text(_stokFiltresiEtiketi(filtre)),
                selected: _seciliStokFiltresi == filtre,
                onSelected: (_) => _stokFiltresiSec(filtre),
              ),
            ),
          ],
        ),
        child: ListView(
          children: _stokEkraniHammaddeleri
              .map(
                (HammaddeStokVarligi hammadde) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AdminHammaddeSatiri(
                    hammadde: hammadde,
                    duzenle: () => _hammaddeDuzenle(hammadde),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      _entegrasyonSekmesiIcerigi(),
      AyarlarKarti(
        baslik: 'Yedekleme ve veri aktarim',
        aciklama:
            'Menu verisini JSON olarak disa aktar, gerekirse tek adimda geri yukle.',
        eylem: const SizedBox.shrink(),
        child: _yedeklemeIcerigi(),
      ),
      if (_dagiticiModuAktif) _lisansSekmesiIcerigi(),
    ];
    final int sekmeSayisi = ustSekmeler.length;
    final int baslangicSekmesi = widget.baslangicSekmesi < 0
        ? 0
        : widget.baslangicSekmesi >= sekmeSayisi
        ? sekmeSayisi - 1
        : widget.baslangicSekmesi;

    return DefaultTabController(
      length: sekmeSayisi,
      initialIndex: baslangicSekmesi,
      child: Theme(
        data: ayarlarTema,
        child: SuruklenebilirPopupSablonu(
          materialKullan: false,
          tutamacUstOfset: 140,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Material(
                color: ayarlarTema.colorScheme.surface,
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
                            color: sekmeArkaPlanRengi,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TabBar(
                            labelColor: AnaSayfaRenkSablonu.birincilAksiyon,
                            unselectedLabelColor: sekmeKontrastRengi.withValues(
                              alpha: 0.82,
                            ),
                            indicatorColor: AnaSayfaRenkSablonu.birincilAksiyon,
                            tabs: ustSekmeler,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Expanded(child: TabBarView(children: sekmeIcerikleri)),
                      ],
                    ),
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

  String _stokFiltresiEtiketi(StokUyariFiltresi filtre) {
    switch (filtre) {
      case StokUyariFiltresi.tum:
        return 'Tum';
      case StokUyariFiltresi.uyari:
        return 'Uyari';
      case StokUyariFiltresi.kritik:
        return 'Kritik';
      case StokUyariFiltresi.tukendi:
        return 'Tukendi';
    }
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
