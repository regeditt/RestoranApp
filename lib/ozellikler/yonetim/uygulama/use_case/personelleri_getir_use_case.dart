import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';

class PersonelleriGetirUseCase {
  const PersonelleriGetirUseCase(this._personelDeposu);

  final PersonelDeposu _personelDeposu;

  Future<List<PersonelDurumuVarligi>> call() {
    return _personelDeposu.personelleriGetir();
  }
}
