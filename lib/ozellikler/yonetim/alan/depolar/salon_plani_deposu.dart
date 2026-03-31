import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

abstract class SalonPlaniDeposu {
  Future<List<SalonBolumuVarligi>> bolumleriGetir();

  Future<void> bolumEkle(SalonBolumuVarligi bolum);

  Future<void> bolumGuncelle(SalonBolumuVarligi bolum);

  Future<void> bolumSil(String bolumId);

  Future<void> masaEkle(String bolumId, MasaTanimiVarligi masa);

  Future<void> masaGuncelle({
    required String bolumId,
    required MasaTanimiVarligi masa,
  });

  Future<void> masaSil({required String bolumId, required String masaId});
}
