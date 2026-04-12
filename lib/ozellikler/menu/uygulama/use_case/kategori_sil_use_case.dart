import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';

/// KategoriSilUseCase use-case operasyonunu yurutur.
class KategoriSilUseCase {
  const KategoriSilUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(String kategoriId) {
    return _menuDeposu.kategoriSil(kategoriId);
  }
}
