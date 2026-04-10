import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

/// Salon bolumu ve masa plani operasyonlari icin depo kontrati.
abstract class SalonPlaniDeposu {
  /// Tum salon bolumlerini ve masalarini getirir.
  Future<List<SalonBolumuVarligi>> bolumleriGetir();

  /// Yeni salon bolumu ekler.
  Future<void> bolumEkle(SalonBolumuVarligi bolum);

  /// Mevcut salon bolumu bilgisini gunceller.
  Future<void> bolumGuncelle(SalonBolumuVarligi bolum);

  /// [bolumId] ile eslesen salon bolumunu siler.
  Future<void> bolumSil(String bolumId);

  /// Verilen bolume yeni masa tanimi ekler.
  Future<void> masaEkle(String bolumId, MasaTanimiVarligi masa);

  /// Verilen bolumdeki masa tanimini gunceller.
  Future<void> masaGuncelle({
    required String bolumId,
    required MasaTanimiVarligi masa,
  });

  /// Verilen bolumdeki masa kaydini siler.
  Future<void> masaSil({required String bolumId, required String masaId});
}
