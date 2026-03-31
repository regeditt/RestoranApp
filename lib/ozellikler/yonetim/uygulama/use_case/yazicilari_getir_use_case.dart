import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

class YazicilariGetirUseCase {
  const YazicilariGetirUseCase(this._yaziciDeposu);

  final YaziciDeposu _yaziciDeposu;

  Future<List<YaziciDurumuVarligi>> call() {
    return _yaziciDeposu.yazicilariGetir();
  }
}
