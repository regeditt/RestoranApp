import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

class UrunGuncelleUseCase {
  const UrunGuncelleUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  Future<void> call(UrunVarligi urun) {
    return _menuDeposu.urunGuncelle(urun);
  }
}
