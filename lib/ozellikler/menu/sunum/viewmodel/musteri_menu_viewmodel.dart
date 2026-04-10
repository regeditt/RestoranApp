import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/pos_masa_urun_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategoriye_gore_urunleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategorileri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/urunleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepet_kalemi_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepet_kalemi_sil_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepeti_getir_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepete_urun_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/salon_bolumlerini_getir_use_case.dart';

/// Musteri menu akisindaki UI islemleri icin basari/hata sonucunu tasir.
class MusteriMenuIslemSonucu {
  const MusteriMenuIslemSonucu.basarili([this.mesaj = '']) : basarili = true;

  const MusteriMenuIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

/// POS menu ekraninda kategori, urun, masa/salon ve sepet durumunu yonetir.
class MusteriMenuViewModel extends ChangeNotifier {
  MusteriMenuViewModel({
    required KategorileriGetirUseCase kategorileriGetirUseCase,
    required SepetiGetirUseCase sepetiGetirUseCase,
    required UrunleriGetirUseCase urunleriGetirUseCase,
    required KategoriyeGoreUrunleriGetirUseCase
    kategoriyeGoreUrunleriGetirUseCase,
    required SepeteUrunEkleUseCase sepeteUrunEkleUseCase,
    required SepetKalemiGuncelleUseCase sepetKalemiGuncelleUseCase,
    required SepetKalemiSilUseCase sepetKalemiSilUseCase,
    required SalonBolumleriniGetirUseCase salonBolumleriniGetirUseCase,
  }) : _kategorileriGetirUseCase = kategorileriGetirUseCase,
       _sepetiGetirUseCase = sepetiGetirUseCase,
       _urunleriGetirUseCase = urunleriGetirUseCase,
       _kategoriyeGoreUrunleriGetirUseCase = kategoriyeGoreUrunleriGetirUseCase,
       _sepeteUrunEkleUseCase = sepeteUrunEkleUseCase,
       _sepetKalemiGuncelleUseCase = sepetKalemiGuncelleUseCase,
       _sepetKalemiSilUseCase = sepetKalemiSilUseCase,
       _salonBolumleriniGetirUseCase = salonBolumleriniGetirUseCase;

  factory MusteriMenuViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return MusteriMenuViewModel(
      kategorileriGetirUseCase: servisKaydi.kategorileriGetirUseCase,
      sepetiGetirUseCase: servisKaydi.sepetiGetirUseCase,
      urunleriGetirUseCase: servisKaydi.urunleriGetirUseCase,
      kategoriyeGoreUrunleriGetirUseCase:
          servisKaydi.kategoriyeGoreUrunleriGetirUseCase,
      sepeteUrunEkleUseCase: servisKaydi.sepeteUrunEkleUseCase,
      sepetKalemiGuncelleUseCase: servisKaydi.sepetKalemiGuncelleUseCase,
      sepetKalemiSilUseCase: servisKaydi.sepetKalemiSilUseCase,
      salonBolumleriniGetirUseCase: servisKaydi.salonBolumleriniGetirUseCase,
    );
  }

  final KategorileriGetirUseCase _kategorileriGetirUseCase;
  final SepetiGetirUseCase _sepetiGetirUseCase;
  final UrunleriGetirUseCase _urunleriGetirUseCase;
  final KategoriyeGoreUrunleriGetirUseCase _kategoriyeGoreUrunleriGetirUseCase;
  final SepeteUrunEkleUseCase _sepeteUrunEkleUseCase;
  final SepetKalemiGuncelleUseCase _sepetKalemiGuncelleUseCase;
  final SepetKalemiSilUseCase _sepetKalemiSilUseCase;
  final SalonBolumleriniGetirUseCase _salonBolumleriniGetirUseCase;

  bool _yukleniyor = true;
  List<KategoriVarligi> _kategoriler = const <KategoriVarligi>[];
  List<UrunVarligi> _urunler = const <UrunVarligi>[];
  List<SalonBolumuVarligi> _salonBolumleri = const <SalonBolumuVarligi>[];
  SepetVarligi _sepet = const SepetVarligi(id: 'sep_001', kalemler: []);
  String? _seciliKategoriId;
  String? _seciliSalonBolumuId;
  String? _seciliMasaId;
  int _kategoriIstekSayaci = 0;

  bool get yukleniyor => _yukleniyor;
  List<KategoriVarligi> get kategoriler => _kategoriler;
  List<UrunVarligi> get urunler => _urunler;
  List<SalonBolumuVarligi> get salonBolumleri => _salonBolumleri;
  SepetVarligi get sepet => _sepet;
  String? get seciliKategoriId => _seciliKategoriId;
  String? get seciliSalonBolumuId => _seciliSalonBolumuId;
  String? get seciliMasaId => _seciliMasaId;

  SalonBolumuVarligi? get seciliSalonBolumu {
    if (_seciliSalonBolumuId == null) {
      return null;
    }
    for (final SalonBolumuVarligi bolum in _salonBolumleri) {
      if (bolum.id == _seciliSalonBolumuId) {
        return bolum;
      }
    }
    return null;
  }

  MasaTanimiVarligi? get seciliMasa {
    final SalonBolumuVarligi? bolum = seciliSalonBolumu;
    if (bolum == null || _seciliMasaId == null) {
      return null;
    }
    for (final MasaTanimiVarligi masa in bolum.masalar) {
      if (masa.id == _seciliMasaId) {
        return masa;
      }
    }
    return null;
  }

  bool get posMasaSeciliMi => seciliSalonBolumu != null && seciliMasa != null;

  PosMasaUrunBaglamiVarligi? get posMasaUrunBaglami {
    final SalonBolumuVarligi? bolum = seciliSalonBolumu;
    final MasaTanimiVarligi? masa = seciliMasa;
    if (bolum == null || masa == null) {
      return null;
    }
    return PosMasaUrunBaglamiVarligi(
      salonBolumu: bolum,
      masa: masa,
      urunler: _urunler,
      seciliKategori: seciliKategori,
    );
  }

  QrMenuBaglamiVarligi? get posBaglami {
    return posMasaUrunBaglami?.qrBaglami;
  }

  String get seciliKategoriAdi {
    for (final KategoriVarligi kategori in _kategoriler) {
      if (kategori.id == _seciliKategoriId) {
        return kategori.ad;
      }
    }
    return 'Tum urunler';
  }

  KategoriVarligi? get seciliKategori {
    final String? kategoriId = _seciliKategoriId;
    if (kategoriId == null) {
      return null;
    }
    for (final KategoriVarligi kategori in _kategoriler) {
      if (kategori.id == kategoriId) {
        return kategori;
      }
    }
    return null;
  }

  Future<MusteriMenuIslemSonucu> verileriYukle() async {
    _yukleniyor = true;
    notifyListeners();
    try {
      final List<Object> yuklenenler =
          await Future.wait<Object>(<Future<Object>>[
            _kategorileriGetirUseCase(),
            _sepetiGetirUseCase(),
            _salonBolumleriniGetirUseCase(),
          ]);
      final List<KategoriVarligi> kategoriler =
          yuklenenler[0] as List<KategoriVarligi>;
      final SepetVarligi sepet = yuklenenler[1] as SepetVarligi;
      final List<SalonBolumuVarligi> salonBolumleri =
          yuklenenler[2] as List<SalonBolumuVarligi>;

      String? seciliKategoriId = _seciliKategoriId;
      if (seciliKategoriId != null &&
          kategoriler.every((kategori) => kategori.id != seciliKategoriId)) {
        seciliKategoriId = null;
      }

      final List<UrunVarligi> urunler = seciliKategoriId == null
          ? await _urunleriGetirUseCase()
          : await _kategoriyeGoreUrunleriGetirUseCase(seciliKategoriId);

      String? seciliSalonBolumuId = _seciliSalonBolumuId;
      if (salonBolumleri.isNotEmpty &&
          (seciliSalonBolumuId == null ||
              salonBolumleri.every(
                (bolum) => bolum.id != seciliSalonBolumuId,
              ))) {
        seciliSalonBolumuId = salonBolumleri.first.id;
      }
      final SalonBolumuVarligi? seciliSalonBolumu = _salonBolumuBul(
        salonBolumleri,
        seciliSalonBolumuId,
      );
      String? seciliMasaId = _seciliMasaId;
      if (seciliSalonBolumu == null || seciliSalonBolumu.masalar.isEmpty) {
        seciliMasaId = null;
      } else if (seciliMasaId == null ||
          seciliSalonBolumu.masalar.every((masa) => masa.id != seciliMasaId)) {
        seciliMasaId = seciliSalonBolumu.masalar.first.id;
      }

      _kategoriler = kategoriler;
      _sepet = sepet;
      _seciliKategoriId = seciliKategoriId;
      _urunler = urunler;
      _salonBolumleri = salonBolumleri;
      _seciliSalonBolumuId = seciliSalonBolumuId;
      _seciliMasaId = seciliMasaId;
      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.basarili();
    } catch (_) {
      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.hata('Veriler yuklenemedi');
    }
  }

  Future<MusteriMenuIslemSonucu> kategoriSec(String kategoriId) async {
    final int istekNo = ++_kategoriIstekSayaci;
    _seciliKategoriId = kategoriId;
    _yukleniyor = true;
    notifyListeners();

    try {
      final List<UrunVarligi> urunler =
          await _kategoriyeGoreUrunleriGetirUseCase(kategoriId);

      if (istekNo != _kategoriIstekSayaci) {
        return const MusteriMenuIslemSonucu.basarili();
      }

      _urunler = urunler;
      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.basarili();
    } catch (_) {
      if (istekNo != _kategoriIstekSayaci) {
        return const MusteriMenuIslemSonucu.basarili();
      }

      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.hata('Kategori urunleri yuklenemedi');
    }
  }

  Future<MusteriMenuIslemSonucu> tumKategorileriGoster() async {
    final int istekNo = ++_kategoriIstekSayaci;
    _seciliKategoriId = null;
    _yukleniyor = true;
    notifyListeners();

    try {
      final List<UrunVarligi> urunler = await _urunleriGetirUseCase();
      if (istekNo != _kategoriIstekSayaci) {
        return const MusteriMenuIslemSonucu.basarili();
      }
      _urunler = urunler;
      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.basarili();
    } catch (_) {
      if (istekNo != _kategoriIstekSayaci) {
        return const MusteriMenuIslemSonucu.basarili();
      }
      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.hata('Tum urunler yuklenemedi');
    }
  }

  void salonBolumuSec(String bolumId) {
    final SalonBolumuVarligi? bolum = _salonBolumuBul(_salonBolumleri, bolumId);
    if (bolum == null) {
      return;
    }
    final String? sonrakiMasaId = bolum.masalar.isEmpty
        ? null
        : bolum.masalar.first.id;
    if (_seciliSalonBolumuId == bolum.id && _seciliMasaId == sonrakiMasaId) {
      return;
    }
    _seciliSalonBolumuId = bolum.id;
    _seciliMasaId = sonrakiMasaId;
    notifyListeners();
  }

  void masaSec(String masaId) {
    final SalonBolumuVarligi? bolum = seciliSalonBolumu;
    if (bolum == null || bolum.masalar.every((masa) => masa.id != masaId)) {
      return;
    }
    if (_seciliMasaId == masaId) {
      return;
    }
    _seciliMasaId = masaId;
    notifyListeners();
  }

  SalonBolumuVarligi? _salonBolumuBul(
    List<SalonBolumuVarligi> bolumler,
    String? bolumId,
  ) {
    if (bolumId == null) {
      return null;
    }
    for (final SalonBolumuVarligi bolum in bolumler) {
      if (bolum.id == bolumId) {
        return bolum;
      }
    }
    return null;
  }

  Future<MusteriMenuIslemSonucu> sepeteEkle(
    UrunVarligi urun, {
    int adet = 1,
    String? secenekId,
    String? notMetni,
  }) async {
    if (!urun.stoktaMi) {
      return MusteriMenuIslemSonucu.hata('${urun.ad} su an stokta yok');
    }

    _yukleniyor = true;
    notifyListeners();

    try {
      _sepet = await _sepeteUrunEkleUseCase(
        urunId: urun.id,
        adet: adet,
        secenekId: secenekId,
        notMetni: notMetni,
      );
      _yukleniyor = false;
      notifyListeners();
      return MusteriMenuIslemSonucu.basarili(
        '$adet x ${urun.ad} sepete eklendi',
      );
    } catch (_) {
      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.hata('Urun sepete eklenemedi');
    }
  }

  Future<MusteriMenuIslemSonucu> kalemAdediniGuncelle({
    required SepetKalemiVarligi kalem,
    required int yeniAdet,
  }) async {
    _yukleniyor = true;
    notifyListeners();

    try {
      _sepet = yeniAdet <= 0
          ? await _sepetKalemiSilUseCase(kalem.id)
          : await _sepetKalemiGuncelleUseCase(
              kalemId: kalem.id,
              adet: yeniAdet,
            );
      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.basarili();
    } catch (_) {
      _yukleniyor = false;
      notifyListeners();
      return const MusteriMenuIslemSonucu.hata('Adisyon guncellenemedi');
    }
  }

  Future<MusteriMenuIslemSonucu> siparisSonrasiYenile() async {
    final MusteriMenuIslemSonucu sonuc = await verileriYukle();
    if (sonuc.basarili) {
      return sonuc;
    }
    return const MusteriMenuIslemSonucu.hata('Sepet durumu yenilenemedi');
  }
}
