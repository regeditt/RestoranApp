import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';

/// SalonBolumuSilUseCase use-case operasyonunu yurutur.
class SalonBolumuSilUseCase {
  const SalonBolumuSilUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(String bolumId) {
    return _depo.bolumSil(bolumId);
  }
}
