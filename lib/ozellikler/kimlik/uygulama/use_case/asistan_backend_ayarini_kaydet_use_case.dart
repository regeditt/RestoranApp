import 'package:restoran_app/ozellikler/kimlik/alan/depolar/asistan_backend_ayar_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_backend_ayar_varligi.dart';

class AsistanBackendAyariniKaydetUseCase {
  const AsistanBackendAyariniKaydetUseCase(this._depo);

  final AsistanBackendAyarDeposu _depo;

  Future<void> call({required String tabanUrl, String apiAnahtari = ''}) {
    return _depo.kaydet(
      AsistanBackendAyarVarligi(
        tabanUrl: tabanUrl.trim(),
        apiAnahtari: apiAnahtari.trim(),
      ),
    );
  }
}
