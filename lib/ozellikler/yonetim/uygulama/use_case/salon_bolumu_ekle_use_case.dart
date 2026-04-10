import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

/// SalonBolumuEkleUseCase use-case operasyonunu yurutur.
class SalonBolumuEkleUseCase {
  const SalonBolumuEkleUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(SalonBolumuVarligi bolum) {
    return _depo.bolumEkle(bolum);
  }
}
