import 'package:restoran_app/ozellikler/rezervasyon/alan/depolar/rezervasyon_deposu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/enumlar/rezervasyon_durumu.dart';

class RezervasyonDurumuGuncelleUseCase {
  const RezervasyonDurumuGuncelleUseCase(this._depo);

  final RezervasyonDeposu _depo;

  Future<void> call({
    required String rezervasyonId,
    required RezervasyonDurumu durum,
  }) {
    return _depo.rezervasyonDurumuGuncelle(
      rezervasyonId: rezervasyonId,
      durum: durum,
    );
  }
}
