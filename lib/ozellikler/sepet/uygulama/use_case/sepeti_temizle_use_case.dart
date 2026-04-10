import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';

/// SepetiTemizleUseCase use-case operasyonunu yurutur.
class SepetiTemizleUseCase {
  const SepetiTemizleUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call() {
    return _sepetDeposu.sepetiTemizle();
  }
}
