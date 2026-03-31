import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';

class MasaSilUseCase {
  const MasaSilUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  Future<void> call({required String bolumId, required String masaId}) {
    return _depo.masaSil(bolumId: bolumId, masaId: masaId);
  }
}
