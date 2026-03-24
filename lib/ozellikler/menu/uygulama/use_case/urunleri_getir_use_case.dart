import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

class UrunleriGetirUseCase {
  const UrunleriGetirUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  Future<List<UrunVarligi>> call() {
    return _menuDeposu.urunleriGetir();
  }
}
