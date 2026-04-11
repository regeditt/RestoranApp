import 'package:restoran_app/ozellikler/rezervasyon/alan/depolar/rezervasyon_deposu.dart';

class RezervasyonSilUseCase {
  const RezervasyonSilUseCase(this._depo);

  final RezervasyonDeposu _depo;

  Future<void> call(String rezervasyonId) {
    return _depo.rezervasyonSil(rezervasyonId);
  }
}
