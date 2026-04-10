import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_mock.dart';

class KimlikDeposuGercek implements KimlikDeposu {
  KimlikDeposuGercek([KimlikDeposu? icDepo])
    : _icDepo = icDepo ?? KimlikDeposuMock();

  final KimlikDeposu _icDepo;

  @override
  Future<KullaniciVarligi?> aktifKullaniciGetir() {
    return _icDepo.aktifKullaniciGetir();
  }

  @override
  Future<void> cikisYap() {
    return _icDepo.cikisYap();
  }

  @override
  Future<KullaniciVarligi> girisYap({
    required String telefon,
    required String sifre,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adSoyad,
    String? adresMetni,
  }) {
    return _icDepo.girisYap(
      telefon: telefon,
      sifre: sifre,
      rol: rol,
      adSoyad: adSoyad,
      adresMetni: adresMetni,
    );
  }

  @override
  Future<KullaniciVarligi> hesapOlustur({
    required String telefon,
    required String sifre,
    required String adSoyad,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adresMetni,
    bool aktifYap = true,
  }) {
    return _icDepo.hesapOlustur(
      telefon: telefon,
      sifre: sifre,
      adSoyad: adSoyad,
      rol: rol,
      adresMetni: adresMetni,
      aktifYap: aktifYap,
    );
  }

  @override
  Future<MisafirBilgisiVarligi> misafirOlustur({
    required String adSoyad,
    required String telefon,
    String? eposta,
    String? adres,
  }) {
    return _icDepo.misafirOlustur(
      adSoyad: adSoyad,
      telefon: telefon,
      eposta: eposta,
      adres: adres,
    );
  }
}
