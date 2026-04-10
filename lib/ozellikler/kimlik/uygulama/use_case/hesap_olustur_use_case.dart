import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';

/// HesapOlusturUseCase use-case operasyonunu yurutur.
class HesapOlusturUseCase {
  const HesapOlusturUseCase(this._kimlikDeposu);

  final KimlikDeposu _kimlikDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<KullaniciVarligi> call({
    required String telefon,
    required String sifre,
    required String adSoyad,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adresMetni,
    bool aktifYap = true,
  }) {
    return _kimlikDeposu.hesapOlustur(
      telefon: telefon,
      sifre: sifre,
      adSoyad: adSoyad,
      rol: rol,
      adresMetni: adresMetni,
      aktifYap: aktifYap,
    );
  }
}
