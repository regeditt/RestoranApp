import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';

class YaziciSilUseCase {
  const YaziciSilUseCase(this._yaziciDeposu);

  final YaziciDeposu _yaziciDeposu;

  Future<void> call(String yaziciId) {
    return _yaziciDeposu.yaziciSil(yaziciId);
  }
}
