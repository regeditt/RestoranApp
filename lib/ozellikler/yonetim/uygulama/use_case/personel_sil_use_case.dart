import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';

/// PersonelSilUseCase use-case operasyonunu yurutur.
class PersonelSilUseCase {
  const PersonelSilUseCase(this._personelDeposu);

  final PersonelDeposu _personelDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<void> call(String kimlik) {
    return _personelDeposu.personelSil(kimlik);
  }
}
