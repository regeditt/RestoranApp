import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

class SepetiGetirUseCase {
  const SepetiGetirUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  Future<SepetVarligi> call() {
    return _sepetDeposu.sepetiGetir();
  }
}
