import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

/// SepetiGetirUseCase use-case operasyonunu yurutur.
class SepetiGetirUseCase {
  const SepetiGetirUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<SepetVarligi> call() {
    return _sepetDeposu.sepetiGetir();
  }
}
