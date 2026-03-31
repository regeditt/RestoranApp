import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';

class CikisYapUseCase {
  const CikisYapUseCase(this._kimlikDeposu);

  final KimlikDeposu _kimlikDeposu;

  Future<void> call() {
    return _kimlikDeposu.cikisYap();
  }
}
