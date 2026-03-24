import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

abstract class KimlikDeposu {
  Future<KullaniciVarligi?> aktifKullaniciGetir();

  Future<KullaniciVarligi> girisYap({
    required String telefon,
    required String sifre,
  });

  Future<MisafirBilgisiVarligi> misafirOlustur({
    required String adSoyad,
    required String telefon,
    String? eposta,
  });

  Future<void> cikisYap();
}
