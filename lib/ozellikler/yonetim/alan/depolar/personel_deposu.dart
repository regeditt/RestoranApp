import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';

abstract class PersonelDeposu {
  Future<List<PersonelDurumuVarligi>> personelleriGetir();

  Future<void> personelSil(String kimlik);
}
