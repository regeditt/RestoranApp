import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

abstract class YaziciDeposu {
  Future<List<YaziciDurumuVarligi>> yazicilariGetir();

  Future<YaziciDurumuVarligi> yaziciEkle(YaziciDurumuVarligi yazici);

  Future<YaziciDurumuVarligi> yaziciGuncelle(YaziciDurumuVarligi yazici);

  Future<void> yaziciSil(String yaziciId);
}
