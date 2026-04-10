import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

/// MisafirOlusturUseCase use-case operasyonunu yurutur.
class MisafirOlusturUseCase {
  const MisafirOlusturUseCase(this._kimlikDeposu);

  final KimlikDeposu _kimlikDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<MisafirBilgisiVarligi> call({
    required String adSoyad,
    required String telefon,
    String? eposta,
    String? adres,
  }) {
    return _kimlikDeposu.misafirOlustur(
      adSoyad: adSoyad,
      telefon: telefon,
      eposta: eposta,
      adres: adres,
    );
  }
}
