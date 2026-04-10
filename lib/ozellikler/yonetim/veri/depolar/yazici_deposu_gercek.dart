import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/yazici_deposu_mock.dart';

class YaziciDeposuGercek implements YaziciDeposu {
  YaziciDeposuGercek([YaziciDeposu? icDepo])
    : _icDepo = icDepo ?? YaziciDeposuMock();

  final YaziciDeposu _icDepo;

  @override
  Future<YaziciDurumuVarligi> yaziciEkle(YaziciDurumuVarligi yazici) {
    return _icDepo.yaziciEkle(yazici);
  }

  @override
  Future<YaziciDurumuVarligi> yaziciGuncelle(YaziciDurumuVarligi yazici) {
    return _icDepo.yaziciGuncelle(yazici);
  }

  @override
  Future<void> yaziciSil(String yaziciId) {
    return _icDepo.yaziciSil(yaziciId);
  }

  @override
  Future<List<YaziciDurumuVarligi>> yazicilariGetir() {
    return _icDepo.yazicilariGetir();
  }
}
