import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/personel_deposu_mock.dart';

class PersonelDeposuGercek implements PersonelDeposu {
  PersonelDeposuGercek([PersonelDeposu? icDepo])
    : _icDepo = icDepo ?? PersonelDeposuMock();

  final PersonelDeposu _icDepo;

  @override
  Future<void> personelSil(String kimlik) {
    return _icDepo.personelSil(kimlik);
  }

  @override
  Future<List<PersonelDurumuVarligi>> personelleriGetir() {
    return _icDepo.personelleriGetir();
  }
}
