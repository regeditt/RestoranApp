import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';

/// HammaddeEkleUseCase use-case operasyonunu yurutur.
class HammaddeEkleUseCase {
  const HammaddeEkleUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(HammaddeStokVarligi hammadde) {
    return _stokDeposu.hammaddeEkle(hammadde);
  }
}
