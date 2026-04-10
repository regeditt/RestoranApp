import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';

/// PersonelleriGetirUseCase use-case operasyonunu yurutur.
class PersonelleriGetirUseCase {
  const PersonelleriGetirUseCase(this._personelDeposu);

  final PersonelDeposu _personelDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<List<PersonelDurumuVarligi>> call() {
    return _personelDeposu.personelleriGetir();
  }
}
