import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';

class SepetiTemizleUseCase {
  const SepetiTemizleUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  Future<void> call() {
    return _sepetDeposu.sepetiTemizle();
  }
}
