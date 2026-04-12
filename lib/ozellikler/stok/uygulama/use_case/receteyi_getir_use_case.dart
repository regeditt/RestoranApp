import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';

/// ReceteyiGetirUseCase use-case operasyonunu yurutur.
class ReceteyiGetirUseCase {
  const ReceteyiGetirUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<List<ReceteKalemiVarligi>> call(String urunId) {
    return _stokDeposu.receteyiGetir(urunId);
  }
}
