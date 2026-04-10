import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/aktif_kullanici_getir_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/cikis_yap_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/giris_yap_use_case.dart';

/// Kullaniciya ait tek bir adres kartinin baslik ve metin bilgisini tutar.
class AdresVerisi {
  const AdresVerisi({required this.baslik, required this.adresMetni});

  final String baslik;
  final String adresMetni;
}

/// Hesabim ekranindaki islem cagri sonuclarini (basarili/hata) tasir.
class HesabimIslemSonucu {
  const HesabimIslemSonucu.basarili([this.mesaj = '']) : basarili = true;

  const HesabimIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

/// Hesabim ekraninda aktif kullanici, profil duzenleme ve adres listesini yonetir.
class HesabimViewModel extends ChangeNotifier {
  HesabimViewModel({
    required AktifKullaniciGetirUseCase aktifKullaniciGetirUseCase,
    required GirisYapUseCase girisYapUseCase,
    required CikisYapUseCase cikisYapUseCase,
  }) : _aktifKullaniciGetirUseCase = aktifKullaniciGetirUseCase,
       _girisYapUseCase = girisYapUseCase,
       _cikisYapUseCase = cikisYapUseCase;

  factory HesabimViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return HesabimViewModel(
      aktifKullaniciGetirUseCase: servisKaydi.aktifKullaniciGetirUseCase,
      girisYapUseCase: servisKaydi.girisYapUseCase,
      cikisYapUseCase: servisKaydi.cikisYapUseCase,
    );
  }

  final AktifKullaniciGetirUseCase _aktifKullaniciGetirUseCase;
  final GirisYapUseCase _girisYapUseCase;
  final CikisYapUseCase _cikisYapUseCase;

  KullaniciVarligi? _aktifKullanici;
  bool _yukleniyor = true;
  bool _islemde = false;
  bool _profilDuzenleniyor = false;
  List<AdresVerisi> _adresler = const <AdresVerisi>[
    AdresVerisi(baslik: 'Ev', adresMetni: 'Ataturk Mah. 14. Sok. No:7 Daire:4'),
    AdresVerisi(baslik: 'Ofis', adresMetni: 'Cumhuriyet Cad. No:24 Kat:2'),
  ];

  KullaniciVarligi? get aktifKullanici => _aktifKullanici;
  bool get yukleniyor => _yukleniyor;
  bool get islemde => _islemde;
  bool get profilDuzenleniyor => _profilDuzenleniyor;
  List<AdresVerisi> get adresler => _adresler;

  Future<HesabimIslemSonucu> kullaniciYukle() async {
    try {
      _aktifKullanici = await _aktifKullaniciGetirUseCase();
      _yukleniyor = false;
      notifyListeners();
      return const HesabimIslemSonucu.basarili();
    } catch (_) {
      _yukleniyor = false;
      notifyListeners();
      return const HesabimIslemSonucu.hata('Kullanici bilgileri yuklenemedi');
    }
  }

  Future<HesabimIslemSonucu> girisYap({
    required String telefon,
    required String sifre,
  }) async {
    _islemde = true;
    notifyListeners();
    try {
      _aktifKullanici = await _girisYapUseCase(
        telefon: telefon.trim(),
        sifre: sifre.trim(),
      );
      _profilDuzenleniyor = false;
      return const HesabimIslemSonucu.basarili();
    } catch (_) {
      return const HesabimIslemSonucu.hata('Giris yapilamadi');
    } finally {
      _islemde = false;
      notifyListeners();
    }
  }

  Future<HesabimIslemSonucu> cikisYap() async {
    _islemde = true;
    notifyListeners();
    try {
      await _cikisYapUseCase();
      _aktifKullanici = null;
      _profilDuzenleniyor = false;
      return const HesabimIslemSonucu.basarili();
    } catch (_) {
      return const HesabimIslemSonucu.hata('Cikis yapilamadi');
    } finally {
      _islemde = false;
      notifyListeners();
    }
  }

  void profilDuzenlemeyiAc() {
    if (_aktifKullanici == null) {
      return;
    }
    _profilDuzenleniyor = true;
    notifyListeners();
  }

  HesabimIslemSonucu profilKaydet({
    required String adSoyad,
    required String telefon,
    required String eposta,
  }) {
    final KullaniciVarligi? kullanici = _aktifKullanici;
    if (kullanici == null) {
      return const HesabimIslemSonucu.hata('Aktif kullanici bulunamadi');
    }

    _aktifKullanici = KullaniciVarligi(
      id: kullanici.id,
      adSoyad: adSoyad.trim(),
      telefon: telefon.trim(),
      eposta: eposta.trim().isEmpty ? null : eposta.trim(),
      adresMetni: kullanici.adresMetni,
      rol: kullanici.rol,
      aktifMi: kullanici.aktifMi,
    );
    _profilDuzenleniyor = false;
    notifyListeners();
    return const HesabimIslemSonucu.basarili('Profil bilgileri guncellendi');
  }

  HesabimIslemSonucu adresEkle({
    required String baslik,
    required String adresMetni,
  }) {
    final String temizBaslik = baslik.trim();
    final String temizAdres = adresMetni.trim();
    if (temizBaslik.isEmpty || temizAdres.isEmpty) {
      return const HesabimIslemSonucu.hata(
        'Adres basligi ve adres metni gerekli',
      );
    }

    _adresler = <AdresVerisi>[
      ..._adresler,
      AdresVerisi(baslik: temizBaslik, adresMetni: temizAdres),
    ];
    notifyListeners();
    return const HesabimIslemSonucu.basarili('Adres eklendi');
  }

  HesabimIslemSonucu adresSil(AdresVerisi adres) {
    _adresler = _adresler
        .where((AdresVerisi mevcutAdres) => mevcutAdres != adres)
        .toList();
    notifyListeners();
    return const HesabimIslemSonucu.basarili('Adres kaldirildi');
  }
}
