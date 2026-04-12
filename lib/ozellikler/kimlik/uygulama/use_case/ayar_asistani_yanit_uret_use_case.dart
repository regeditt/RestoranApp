import 'package:restoran_app/ozellikler/kimlik/alan/servisler/ayar_asistani_yanitlayici.dart';

class AyarAsistaniYanitUretUseCase {
  const AyarAsistaniYanitUretUseCase(this._yanitlayici);

  final AyarAsistaniYanitlayici _yanitlayici;

  String get acilisMesaji => _yanitlayici.acilisMesaji;

  List<String> get hizliSoruEtiketleri => _yanitlayici.hizliSoruEtiketleri;

  Future<String> call(String soru) {
    return _yanitlayici.yanitUret(soru);
  }
}
