import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

class UrunEkleUseCase {
  const UrunEkleUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  Future<void> call(UrunVarligi urun) {
    return _menuDeposu.urunEkle(urun);
  }
}
