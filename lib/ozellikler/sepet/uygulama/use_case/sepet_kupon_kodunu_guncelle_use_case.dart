import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

class SepetKuponKodunuGuncelleUseCase {
  const SepetKuponKodunuGuncelleUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  Future<SepetVarligi> call(String? kuponKodu) {
    return _sepetDeposu.kuponKoduGuncelle(kuponKodu);
  }
}
