import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';

/// Personel listeleme ve silme operasyonlari icin depo kontrati.
abstract class PersonelDeposu {
  /// Tum personel kayitlarini durum bilgileriyle getirir.
  Future<List<PersonelDurumuVarligi>> personelleriGetir();

  /// [kimlik] ile eslesen personel kaydini siler.
  Future<void> personelSil(String kimlik);
}
