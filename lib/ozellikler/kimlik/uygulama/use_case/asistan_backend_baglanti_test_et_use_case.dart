import 'package:restoran_app/ozellikler/kimlik/alan/servisler/asistan_api_istemcisi.dart';

class AsistanBackendBaglantiTestEtUseCase {
  const AsistanBackendBaglantiTestEtUseCase(this._apiIstemcisi);

  final AsistanApiIstemcisi _apiIstemcisi;

  Future<bool> call(String tabanUrl, {String apiAnahtari = ''}) async {
    final String temizUrl = tabanUrl.trim();
    if (temizUrl.isEmpty) {
      return false;
    }
    return _apiIstemcisi.baglantiTestEt(
      temizUrl,
      apiAnahtari: apiAnahtari.trim(),
    );
  }
}
