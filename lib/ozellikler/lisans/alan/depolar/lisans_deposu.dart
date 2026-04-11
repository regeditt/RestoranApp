/// Lisans anahtari saklama/okuma operasyonlari icin depo kontrati.
abstract class LisansDeposu {
  /// Kayitli lisans anahtarini getirir.
  ///
  /// Lisans kaydi yoksa `null` dondurur.
  Future<String?> kayitliLisansAnahtariGetir();

  /// Lisans anahtarini kalici olarak kaydeder.
  Future<void> lisansAnahtariKaydet(String lisansAnahtari);

  /// Deneme suresi baslangic tarihini getirir.
  Future<DateTime?> denemeBaslangicTarihiGetir();

  /// Deneme suresi baslangic tarihini kalici olarak kaydeder.
  Future<void> denemeBaslangicTarihiKaydet(DateTime baslangicTarihi);

  /// Kayitli lisans anahtarini temizler.
  Future<void> lisansTemizle();
}
