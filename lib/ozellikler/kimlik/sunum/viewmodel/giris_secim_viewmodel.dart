import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/giris_yap_use_case.dart';

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

class GirisSecimViewModel extends ChangeNotifier {
  GirisSecimViewModel({required GirisYapUseCase girisYapUseCase})
    : _girisYapUseCase = girisYapUseCase;

  factory GirisSecimViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return GirisSecimViewModel(girisYapUseCase: servisKaydi.girisYapUseCase);
  }

  final GirisYapUseCase _girisYapUseCase;

  PersonelGirisModu _seciliMod = PersonelGirisModu.garson;
  bool _islemde = false;

  PersonelGirisModu get seciliMod => _seciliMod;
  bool get islemde => _islemde;

  void modSec(PersonelGirisModu mod) {
    if (_seciliMod == mod) {
      return;
    }
    _seciliMod = mod;
    notifyListeners();
  }

  Future<GirisSecimIslemSonucu> devamEt({
    required String kullaniciAdi,
    required String sifre,
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

    _islemde = true;
    notifyListeners();
    try {
      await _girisYapUseCase(
        telefon: temizKullaniciAdi,
        sifre: temizSifre,
        rol: _seciliMod == PersonelGirisModu.garson
            ? KullaniciRolu.garson
            : KullaniciRolu.yonetici,
        adSoyad: temizKullaniciAdi,
      );
      return GirisSecimIslemSonucu.basarili(
        hedef: hedef ?? _seciliMod.ilkHedef,
      );
    } catch (_) {
      return const GirisSecimIslemSonucu.hata('Giris yapilamadi');
    } finally {
      _islemde = false;
      notifyListeners();
    }
  }
}
