import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

/// Yazici kayit ve durum operasyonlari icin depo kontrati.
abstract class YaziciDeposu {
  /// Tum yazici kayitlarini getirir.
  Future<List<YaziciDurumuVarligi>> yazicilariGetir();

  /// Yeni yazici kaydi ekler ve olusan kaydi dondurur.
  Future<YaziciDurumuVarligi> yaziciEkle(YaziciDurumuVarligi yazici);

  /// Mevcut yazici kaydini gunceller ve guncel kaydi dondurur.
  Future<YaziciDurumuVarligi> yaziciGuncelle(YaziciDurumuVarligi yazici);

  /// [yaziciId] ile eslesen yazici kaydini siler.
  Future<void> yaziciSil(String yaziciId);
}
