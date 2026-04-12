import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

/// MasaEkleUseCase use-case operasyonunu yurutur.
class MasaEkleUseCase {
  const MasaEkleUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(String bolumId, MasaTanimiVarligi masa) {
    return _depo.masaEkle(bolumId, masa);
  }
}
