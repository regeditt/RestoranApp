import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';

class UrunSilUseCase {
  const UrunSilUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  Future<void> call(String urunId) {
    return _menuDeposu.urunSil(urunId);
  }
}
