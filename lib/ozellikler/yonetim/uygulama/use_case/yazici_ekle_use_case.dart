import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

class YaziciEkleUseCase {
  const YaziciEkleUseCase(this._yaziciDeposu);

  final YaziciDeposu _yaziciDeposu;

  Future<YaziciDurumuVarligi> call(YaziciDurumuVarligi yazici) {
    return _yaziciDeposu.yaziciEkle(yazici);
  }
}
