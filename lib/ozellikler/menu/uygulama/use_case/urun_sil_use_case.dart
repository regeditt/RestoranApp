import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';

/// UrunSilUseCase use-case operasyonunu yurutur.
class UrunSilUseCase {
  const UrunSilUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(String urunId) {
    return _menuDeposu.urunSil(urunId);
  }
}
