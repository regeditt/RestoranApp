import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

/// UrunGuncelleUseCase use-case operasyonunu yurutur.
class UrunGuncelleUseCase {
  const UrunGuncelleUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(UrunVarligi urun) {
    return _menuDeposu.urunGuncelle(urun);
  }
}
