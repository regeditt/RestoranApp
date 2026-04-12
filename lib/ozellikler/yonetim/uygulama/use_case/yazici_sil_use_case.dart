import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';

/// YaziciSilUseCase use-case operasyonunu yurutur.
class YaziciSilUseCase {
  const YaziciSilUseCase(this._yaziciDeposu);

  final YaziciDeposu _yaziciDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(String yaziciId) {
    return _yaziciDeposu.yaziciSil(yaziciId);
  }
}
