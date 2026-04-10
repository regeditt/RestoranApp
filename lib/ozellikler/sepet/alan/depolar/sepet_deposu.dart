import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

/// Sepet operasyonlari icin depo kontrati.
abstract class SepetDeposu {
  /// Guncel sepet icerigini getirir.
  Future<SepetVarligi> sepetiGetir();

  /// Sepete urun ekler ve guncel sepeti dondurur.
  Future<SepetVarligi> urunEkle({
    required String urunId,
    required int adet,
    String? secenekId,
    String? notMetni,
  });

  /// Verilen sepet kaleminin adet bilgisini gunceller.
  Future<SepetVarligi> kalemGuncelle({
    required String kalemId,
    required int adet,
  });

  /// Sepetten [kalemId] ile eslesen kalemi siler.
  Future<SepetVarligi> kalemSil(String kalemId);

  /// Sepeti tum kalemlerden temizler.
  Future<void> sepetiTemizle();
}
