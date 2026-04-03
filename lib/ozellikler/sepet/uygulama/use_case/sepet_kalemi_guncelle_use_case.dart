import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

class SepetKalemiGuncelleUseCase {
  const SepetKalemiGuncelleUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  Future<SepetVarligi> call({required String kalemId, required int adet}) {
    return _sepetDeposu.kalemGuncelle(kalemId: kalemId, adet: adet);
  }
}
