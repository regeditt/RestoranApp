import 'package:restoran_app/ozellikler/rezervasyon/alan/depolar/rezervasyon_deposu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/varliklar/rezervasyon_varligi.dart';

class RezervasyonlariGetirUseCase {
  const RezervasyonlariGetirUseCase(this._depo);

  final RezervasyonDeposu _depo;

  Future<List<RezervasyonVarligi>> call({DateTime? gun}) {
    return _depo.rezervasyonlariGetir(gun: gun);
  }
}
