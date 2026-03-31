import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';

class HammaddeGuncelleUseCase {
  const HammaddeGuncelleUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  Future<void> call(HammaddeStokVarligi hammadde) {
    return _stokDeposu.hammaddeGuncelle(hammadde);
  }
}
