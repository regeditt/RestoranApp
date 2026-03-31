import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class SalonBolumuGuncelleUseCase {
  const SalonBolumuGuncelleUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  Future<void> call(SalonBolumuVarligi bolum) {
    return _depo.bolumGuncelle(bolum);
  }
}
