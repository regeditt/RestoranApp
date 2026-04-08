import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';

class PersonelSilUseCase {
  const PersonelSilUseCase(this._personelDeposu);

  final PersonelDeposu _personelDeposu;

  Future<void> call(String kimlik) {
    return _personelDeposu.personelSil(kimlik);
  }
}
