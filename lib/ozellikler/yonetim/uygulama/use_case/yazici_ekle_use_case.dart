import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

/// YaziciEkleUseCase use-case operasyonunu yurutur.
class YaziciEkleUseCase {
  const YaziciEkleUseCase(this._yaziciDeposu);

  final YaziciDeposu _yaziciDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<YaziciDurumuVarligi> call(YaziciDurumuVarligi yazici) {
    return _yaziciDeposu.yaziciEkle(yazici);
  }
}
