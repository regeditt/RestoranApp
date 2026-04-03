import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

class SepetKalemiSilUseCase {
  const SepetKalemiSilUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  Future<SepetVarligi> call(String kalemId) {
    return _sepetDeposu.kalemSil(kalemId);
  }
}
