import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/giris_yap_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/hesap_olustur_use_case.dart';

enum GirisHedefi { pos, yonetim, mutfak }

enum PersonelGirisModu {
  garson(
    'Garson girisi',
    'Servis operasyonu ve masa akisina gec.',
    'Garson olarak giris yap',
    GirisHedefi.pos,
  ),
  yonetici(
    'Yonetici girisi',
    'Yonetim paneli, mutfak ve operasyon ekranlarini ac.',
    'Yonetici olarak giris yap',
    GirisHedefi.yonetim,
  );

  const PersonelGirisModu(
    this.baslik,
    this.aciklama,
    this.butonMetni,
    this.ilkHedef,
  );

  final String baslik;
  final String aciklama;
  final String butonMetni;
  final GirisHedefi ilkHedef;
}

enum KimlikEkranModu {
  girisYap('Giris yap', 'Mevcut personel hesabi ile devam et.'),
  hesapOlustur('Hesap olustur', 'Secili rol icin yeni personel hesabi ac.');

  const KimlikEkranModu(this.baslik, this.aciklama);

  final String baslik;
  final String aciklama;
}

/// Giris/hesap olusturma denemelerinin sonucunu ve hedef ekran bilgisini tasir.
class GirisSecimIslemSonucu {
  const GirisSecimIslemSonucu._({
    required this.basarili,
    this.mesaj = '',
    this.hedef,
  });

  const GirisSecimIslemSonucu.basarili({required GirisHedefi hedef})
    : this._(basarili: true, hedef: hedef);

  const GirisSecimIslemSonucu.hata(String mesaj)
    : this._(basarili: false, mesaj: mesaj);

  final bool basarili;
  final String mesaj;
  final GirisHedefi? hedef;
}

/// Personel giris akisini, secili rol modunu ve ekran yonlendirmesini yonetir.
class GirisSecimViewModel extends ChangeNotifier {
  GirisSecimViewModel({
    required GirisYapUseCase girisYapUseCase,
    required HesapOlusturUseCase hesapOlusturUseCase,
  }) : _girisYapUseCase = girisYapUseCase,
       _hesapOlusturUseCase = hesapOlusturUseCase;

  factory GirisSecimViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return GirisSecimViewModel(
      girisYapUseCase: servisKaydi.girisYapUseCase,
      hesapOlusturUseCase: servisKaydi.hesapOlusturUseCase,
    );
  }

  final GirisYapUseCase _girisYapUseCase;
  final HesapOlusturUseCase _hesapOlusturUseCase;

  PersonelGirisModu _seciliMod = PersonelGirisModu.garson;
  KimlikEkranModu _ekranModu = KimlikEkranModu.girisYap;
  bool _islemde = false;

  PersonelGirisModu get seciliMod => _seciliMod;
  KimlikEkranModu get ekranModu => _ekranModu;
  bool get islemde => _islemde;
  bool get hesapOlusturmaModu => _ekranModu == KimlikEkranModu.hesapOlustur;
  List<KimlikEkranModu> get kullanilabilirEkranModlari =>
      _seciliMod == PersonelGirisModu.yonetici
      ? KimlikEkranModu.values
      : const <KimlikEkranModu>[KimlikEkranModu.girisYap];

  String get formBaslik => hesapOlusturmaModu
      ? '${_seciliMod.baslik} hesabi olustur'
      : _seciliMod.baslik;

  String get formAciklama => hesapOlusturmaModu
      ? '${_seciliMod.aciklama} Yeni hesap olusturuldugunda oturum acilip ilgili ekrana gecilir.'
      : _seciliMod.aciklama;

  String get anaAksiyonMetni => hesapOlusturmaModu
      ? '${_seciliMod.baslik} olustur'
      : _seciliMod.butonMetni;

  void modSec(PersonelGirisModu mod) {
    if (_seciliMod == mod) {
      return;
    }
    _seciliMod = mod;
    if (_seciliMod != PersonelGirisModu.yonetici &&
        _ekranModu == KimlikEkranModu.hesapOlustur) {
      _ekranModu = KimlikEkranModu.girisYap;
    }
    notifyListeners();
  }

  void ekranModuSec(KimlikEkranModu mod) {
    if (!kullanilabilirEkranModlari.contains(mod)) {
      return;
    }
    if (_ekranModu == mod) {
      return;
    }
    _ekranModu = mod;
    notifyListeners();
  }

  Future<GirisSecimIslemSonucu> devamEt({
    required String kullaniciAdi,
    required String sifre,
    String adSoyad = '',
    GirisHedefi? hedef,
  }) async {
    if (_islemde) {
      return const GirisSecimIslemSonucu.hata('Giris islemi devam ediyor');
    }

    final String temizKullaniciAdi = kullaniciAdi.trim();
    final String temizSifre = sifre.trim();
    if (temizKullaniciAdi.isEmpty || temizSifre.isEmpty) {
      return const GirisSecimIslemSonucu.hata(
        'Kullanici adi ve sifre alanlarini doldur.',
      );
    }
    final String temizAdSoyad = adSoyad.trim();
    if (hesapOlusturmaModu && temizAdSoyad.isEmpty) {
      return const GirisSecimIslemSonucu.hata('Ad soyad alanini doldur.');
    }

    _islemde = true;
    notifyListeners();
    try {
      if (hesapOlusturmaModu) {
        await _hesapOlusturUseCase(
          telefon: temizKullaniciAdi,
          sifre: temizSifre,
          adSoyad: temizAdSoyad,
          rol: _seciliRol,
        );
      } else {
        await _girisYapUseCase(
          telefon: temizKullaniciAdi,
          sifre: temizSifre,
          rol: _seciliRol,
          adSoyad: temizKullaniciAdi,
        );
      }
      return GirisSecimIslemSonucu.basarili(
        hedef: hedef ?? _seciliMod.ilkHedef,
      );
    } on StateError catch (hata) {
      return GirisSecimIslemSonucu.hata(
        _hataMesajiniIyilestir(hata.message.toString()),
      );
    } catch (_) {
      return const GirisSecimIslemSonucu.hata('Giris yapilamadi.');
    } finally {
      _islemde = false;
      notifyListeners();
    }
  }

  String _hataMesajiniIyilestir(String mesaj) {
    final String temizMesaj = mesaj.trim();
    if (temizMesaj != 'Kullanici bulunamadi.') {
      return temizMesaj;
    }
    if (_seciliMod == PersonelGirisModu.garson) {
      return 'Bu cihazda garson hesabi bulunamadi. Veriler cihazlar arasinda otomatik paylasilmaz. Once yonetici girisinden hesap olustur.';
    }
    return 'Bu cihazda yonetici hesabi bulunamadi. Veriler cihazlar arasinda otomatik paylasilmaz. Bu cihazda once hesap olustur.';
  }

  KullaniciRolu get _seciliRol => _seciliMod == PersonelGirisModu.garson
      ? KullaniciRolu.garson
      : KullaniciRolu.yonetici;
}
