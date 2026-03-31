import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';

class KategoriSilUseCase {
  const KategoriSilUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  Future<void> call(String kategoriId) {
    return _menuDeposu.kategoriSil(kategoriId);
  }
}
