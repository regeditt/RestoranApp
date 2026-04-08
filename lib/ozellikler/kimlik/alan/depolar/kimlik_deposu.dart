import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

abstract class KimlikDeposu {
  Future<KullaniciVarligi?> aktifKullaniciGetir();

  Future<KullaniciVarligi> hesapOlustur({
    required String telefon,
    required String sifre,
    required String adSoyad,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adresMetni,
    bool aktifYap = true,
  });

  Future<KullaniciVarligi> girisYap({
    required String telefon,
    required String sifre,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adSoyad,
    String? adresMetni,
  });

  Future<MisafirBilgisiVarligi> misafirOlustur({
    required String adSoyad,
    required String telefon,
    String? eposta,
    String? adres,
  });

  Future<void> cikisYap();
}
