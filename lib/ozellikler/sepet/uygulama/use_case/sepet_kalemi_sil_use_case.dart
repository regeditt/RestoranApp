import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

/// SepetKalemiSilUseCase use-case operasyonunu yurutur.
class SepetKalemiSilUseCase {
  const SepetKalemiSilUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<SepetVarligi> call(String kalemId) {
    return _sepetDeposu.kalemSil(kalemId);
  }
}
