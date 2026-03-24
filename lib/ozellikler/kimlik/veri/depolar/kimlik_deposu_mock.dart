import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

class KimlikDeposuMock implements KimlikDeposu {
  KullaniciVarligi? _aktifKullanici;

  @override
  Future<KullaniciVarligi?> aktifKullaniciGetir() async {
    return _aktifKullanici;
  }

  @override
  Future<void> cikisYap() async {
    _aktifKullanici = null;
  }

  @override
  Future<KullaniciVarligi> girisYap({
    required String telefon,
    required String sifre,
  }) async {
    _aktifKullanici = KullaniciVarligi(
      id: 'kul_001',
      adSoyad: 'Deneme Kullanici',
      telefon: telefon,
      eposta: 'deneme@restoranapp.com',
      rol: KullaniciRolu.musteri,
    );

    return _aktifKullanici!;
  }

  @override
  Future<MisafirBilgisiVarligi> misafirOlustur({
    required String adSoyad,
    required String telefon,
    String? eposta,
  }) async {
    return MisafirBilgisiVarligi(
      adSoyad: adSoyad,
      telefon: telefon,
      eposta: eposta,
    );
  }
}
