import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';

class SalonBolumuSilUseCase {
  const SalonBolumuSilUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  Future<void> call(String bolumId) {
    return _depo.bolumSil(bolumId);
  }
}
