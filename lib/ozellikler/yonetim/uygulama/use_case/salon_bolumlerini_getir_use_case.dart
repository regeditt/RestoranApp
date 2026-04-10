import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

/// SalonBolumleriniGetirUseCase use-case operasyonunu yurutur.
class SalonBolumleriniGetirUseCase {
  const SalonBolumleriniGetirUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<List<SalonBolumuVarligi>> call() {
    return _depo.bolumleriGetir();
  }
}
