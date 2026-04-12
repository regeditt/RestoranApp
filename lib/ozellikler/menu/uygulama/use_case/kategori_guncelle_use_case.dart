import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';

/// KategoriGuncelleUseCase use-case operasyonunu yurutur.
class KategoriGuncelleUseCase {
  const KategoriGuncelleUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(KategoriVarligi kategori) {
    return _menuDeposu.kategoriGuncelle(kategori);
  }
}
