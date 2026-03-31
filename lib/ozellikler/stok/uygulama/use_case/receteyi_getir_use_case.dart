import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';

class ReceteyiGetirUseCase {
  const ReceteyiGetirUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  Future<List<ReceteKalemiVarligi>> call(String urunId) {
    return _stokDeposu.receteyiGetir(urunId);
  }
}
