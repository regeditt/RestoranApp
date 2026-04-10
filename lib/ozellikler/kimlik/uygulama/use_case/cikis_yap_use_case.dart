import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';

/// CikisYapUseCase use-case operasyonunu yurutur.
class CikisYapUseCase {
  const CikisYapUseCase(this._kimlikDeposu);

  final KimlikDeposu _kimlikDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call() {
    return _kimlikDeposu.cikisYap();
  }
}
