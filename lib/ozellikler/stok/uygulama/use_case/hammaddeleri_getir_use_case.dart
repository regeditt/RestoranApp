import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';

/// HammaddeleriGetirUseCase use-case operasyonunu yurutur.
class HammaddeleriGetirUseCase {
  const HammaddeleriGetirUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<List<HammaddeStokVarligi>> call() {
    return _stokDeposu.hammaddeleriGetir();
  }
}
