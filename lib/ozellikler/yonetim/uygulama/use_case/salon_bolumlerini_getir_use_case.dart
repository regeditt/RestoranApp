import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class SalonBolumleriniGetirUseCase {
  const SalonBolumleriniGetirUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  Future<List<SalonBolumuVarligi>> call() {
    return _depo.bolumleriGetir();
  }
}
