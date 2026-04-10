import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';

/// KategorileriGetirUseCase use-case operasyonunu yurutur.
class KategorileriGetirUseCase {
  const KategorileriGetirUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<List<KategoriVarligi>> call() {
    return _menuDeposu.kategorileriGetir();
  }
}
