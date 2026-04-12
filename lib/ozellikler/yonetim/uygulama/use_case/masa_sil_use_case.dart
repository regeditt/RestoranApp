import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';

/// MasaSilUseCase use-case operasyonunu yurutur.
class MasaSilUseCase {
  const MasaSilUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call({required String bolumId, required String masaId}) {
    return _depo.masaSil(bolumId: bolumId, masaId: masaId);
  }
}
