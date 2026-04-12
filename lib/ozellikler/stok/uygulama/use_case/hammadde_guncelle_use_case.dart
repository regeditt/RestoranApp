import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';

/// HammaddeGuncelleUseCase use-case operasyonunu yurutur.
class HammaddeGuncelleUseCase {
  const HammaddeGuncelleUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(HammaddeStokVarligi hammadde) {
    return _stokDeposu.hammaddeGuncelle(hammadde);
  }
}
