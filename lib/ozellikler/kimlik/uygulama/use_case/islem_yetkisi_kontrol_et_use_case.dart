import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/rol_yetki_politikasi.dart';

class IslemYetkisiKontrolEtUseCase {
  const IslemYetkisiKontrolEtUseCase(
    this._kimlikDeposu,
    this._rolYetkiPolitikasi,
  );

  final KimlikDeposu _kimlikDeposu;
  final RolYetkiPolitikasi _rolYetkiPolitikasi;

  Future<bool> call(IslemYetkisi yetki) async {
    final kullanici = await _kimlikDeposu.aktifKullaniciGetir();
    final rol = kullanici?.rol;
    if (rol == null) {
      // Aktif personel baglami olmayan akislarin geriye donuk davranisini korur.
      return true;
    }
    return _rolYetkiPolitikasi.yetkiliMi(rol: rol, yetki: yetki);
  }
}
