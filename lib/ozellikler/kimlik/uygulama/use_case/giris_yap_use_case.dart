import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';

/// GirisYapUseCase use-case operasyonunu yurutur.
class GirisYapUseCase {
  const GirisYapUseCase(this._kimlikDeposu);

  final KimlikDeposu _kimlikDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<KullaniciVarligi> call({
    required String telefon,
    required String sifre,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adSoyad,
    String? adresMetni,
  }) {
    return _kimlikDeposu.girisYap(
      telefon: telefon,
      sifre: sifre,
      rol: rol,
      adSoyad: adSoyad,
      adresMetni: adresMetni,
    );
  }
}
