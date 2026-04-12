import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

/// Kimlik akisindaki oturum ve hesap operasyonlari icin depo kontrati.
abstract class KimlikDeposu {
  /// Aktif oturumu olan kullaniciyi getirir.
  ///
  /// Aktif oturum yoksa `null` dondurur.
  Future<KullaniciVarligi?> aktifKullaniciGetir();

  /// Yeni bir kullanici hesabi olusturur.
  ///
  /// [rol] verilmezse varsayilan olarak `musteri` rolu atanir.
  Future<KullaniciVarligi> hesapOlustur({
    required String telefon,
    required String sifre,
    required String adSoyad,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adresMetni,
    bool aktifYap = true,
  });

  /// Kullanici bilgileriyle giris yapar ve aktif oturumu gunceller.
  Future<KullaniciVarligi> girisYap({
    required String telefon,
    required String sifre,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adSoyad,
    String? adresMetni,
  });

  /// Uyeliksiz siparis akisi icin misafir kaydi olusturur.
  Future<MisafirBilgisiVarligi> misafirOlustur({
    required String adSoyad,
    required String telefon,
    String? eposta,
    String? adres,
  });

  /// Aktif kullanici oturumunu kapatir.
  Future<void> cikisYap();
}
