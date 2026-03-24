import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';

class AktifKullaniciGetirUseCase {
  const AktifKullaniciGetirUseCase(this._kimlikDeposu);

  final KimlikDeposu _kimlikDeposu;

  Future<KullaniciVarligi?> call() {
    return _kimlikDeposu.aktifKullaniciGetir();
  }
}
