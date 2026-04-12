import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

/// UrunEkleUseCase use-case operasyonunu yurutur.
class UrunEkleUseCase {
  const UrunEkleUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(UrunVarligi urun) {
    return _menuDeposu.urunEkle(urun);
  }
}
