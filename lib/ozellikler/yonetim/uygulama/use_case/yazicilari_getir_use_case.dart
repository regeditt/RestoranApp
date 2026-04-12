import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

/// YazicilariGetirUseCase use-case operasyonunu yurutur.
class YazicilariGetirUseCase {
  const YazicilariGetirUseCase(this._yaziciDeposu);

  final YaziciDeposu _yaziciDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<List<YaziciDurumuVarligi>> call() {
    return _yaziciDeposu.yazicilariGetir();
  }
}
