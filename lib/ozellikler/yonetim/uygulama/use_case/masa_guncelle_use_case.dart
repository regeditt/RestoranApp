import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

/// MasaGuncelleUseCase use-case operasyonunu yurutur.
class MasaGuncelleUseCase {
  const MasaGuncelleUseCase(this._depo);

  final SalonPlaniDeposu _depo;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call({
    required String bolumId,
    required MasaTanimiVarligi masa,
  }) {
    return _depo.masaGuncelle(bolumId: bolumId, masa: masa);
  }
}
