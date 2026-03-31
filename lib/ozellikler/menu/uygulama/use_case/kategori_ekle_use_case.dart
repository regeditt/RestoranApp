import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';

class KategoriEkleUseCase {
  const KategoriEkleUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  Future<void> call(KategoriVarligi kategori) {
    return _menuDeposu.kategoriEkle(kategori);
  }
}
