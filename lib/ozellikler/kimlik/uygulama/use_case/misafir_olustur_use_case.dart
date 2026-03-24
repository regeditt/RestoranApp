import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

class MisafirOlusturUseCase {
  const MisafirOlusturUseCase(this._kimlikDeposu);

  final KimlikDeposu _kimlikDeposu;

  Future<MisafirBilgisiVarligi> call({
    required String adSoyad,
    required String telefon,
    String? eposta,
  }) {
    return _kimlikDeposu.misafirOlustur(
      adSoyad: adSoyad,
      telefon: telefon,
      eposta: eposta,
    );
  }
}
