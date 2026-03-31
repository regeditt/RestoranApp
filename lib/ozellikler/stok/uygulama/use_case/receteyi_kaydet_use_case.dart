import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';

class ReceteyiKaydetUseCase {
  const ReceteyiKaydetUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  Future<void> call(String urunId, List<ReceteKalemiVarligi> recete) {
    return _stokDeposu.receteyiKaydet(urunId, recete);
  }
}
