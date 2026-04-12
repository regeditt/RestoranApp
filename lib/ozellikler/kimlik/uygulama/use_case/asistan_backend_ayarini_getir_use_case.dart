import 'package:restoran_app/ozellikler/kimlik/alan/depolar/asistan_backend_ayar_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_backend_ayar_varligi.dart';

class AsistanBackendAyariniGetirUseCase {
  const AsistanBackendAyariniGetirUseCase(this._depo);

  final AsistanBackendAyarDeposu _depo;

  Future<AsistanBackendAyarVarligi> call() async {
    return await _depo.yukle() ??
        const AsistanBackendAyarVarligi(tabanUrl: '', apiAnahtari: '');
  }
}
