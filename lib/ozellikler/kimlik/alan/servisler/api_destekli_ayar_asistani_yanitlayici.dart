import 'package:restoran_app/ozellikler/kimlik/alan/depolar/asistan_backend_ayar_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/asistan_api_istemcisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/ayar_asistani_yanitlayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_backend_ayar_varligi.dart';

class ApiDestekliAyarAsistaniYanitlayici implements AyarAsistaniYanitlayici {
  const ApiDestekliAyarAsistaniYanitlayici({
    required AsistanBackendAyarDeposu backendAyarDeposu,
    required AsistanApiIstemcisi apiIstemcisi,
    required AyarAsistaniYanitlayici yedekYanitlayici,
  }) : _backendAyarDeposu = backendAyarDeposu,
       _apiIstemcisi = apiIstemcisi,
       _yedekYanitlayici = yedekYanitlayici;

  final AsistanBackendAyarDeposu _backendAyarDeposu;
  final AsistanApiIstemcisi _apiIstemcisi;
  final AyarAsistaniYanitlayici _yedekYanitlayici;

  @override
  String get acilisMesaji => _yedekYanitlayici.acilisMesaji;

  @override
  List<String> get hizliSoruEtiketleri => _yedekYanitlayici.hizliSoruEtiketleri;

  @override
  Future<String> yanitUret(String soru) async {
    final AsistanBackendAyarVarligi? ayar = await _backendAyarDeposu.yukle();
    final String tabanUrl = ayar?.tabanUrl.trim() ?? '';
    final String apiAnahtari = ayar?.apiAnahtari.trim() ?? '';
    if (tabanUrl.isEmpty) {
      return _yedekYanitlayici.yanitUret(soru);
    }

    try {
      final String? apiYanit = await _apiIstemcisi.yanitIste(
        tabanUrl: tabanUrl,
        soru: soru,
        apiAnahtari: apiAnahtari,
      );
      if (apiYanit != null && apiYanit.trim().isNotEmpty) {
        return apiYanit.trim();
      }
      return 'AI servisi bos yanit dondurdu. Backend loglarini kontrol edip tekrar dene.';
    } catch (_) {
      return 'AI servisine ulasilamadi. URL/API anahtari ve backend durumunu kontrol et.';
    }
  }
}
