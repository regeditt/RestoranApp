import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';

/// AktifKullaniciGetirUseCase use-case operasyonunu yurutur.
class AktifKullaniciGetirUseCase {
  const AktifKullaniciGetirUseCase(this._kimlikDeposu);

  final KimlikDeposu _kimlikDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<KullaniciVarligi?> call() {
    return _kimlikDeposu.aktifKullaniciGetir();
  }
}
