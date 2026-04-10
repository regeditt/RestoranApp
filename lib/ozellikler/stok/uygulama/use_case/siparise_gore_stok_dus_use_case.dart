import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';

/// SipariseGoreStokDusUseCase use-case operasyonunu yurutur.
class SipariseGoreStokDusUseCase {
  const SipariseGoreStokDusUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(SiparisVarligi siparis) async {
    for (final kalem in siparis.kalemler) {
      final List<ReceteKalemiVarligi> recete = await _stokDeposu.receteyiGetir(
        kalem.urunId,
      );
      for (final ReceteKalemiVarligi receteKalemi in recete) {
        await _stokDeposu.stokDus(
          hammaddeId: receteKalemi.hammaddeId,
          miktar: receteKalemi.miktar * kalem.adet,
        );
      }
    }
  }
}
