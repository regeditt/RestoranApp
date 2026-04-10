abstract class AyarAsistaniYanitlayici {
  String get acilisMesaji;

  List<String> get hizliSoruEtiketleri;

  Future<String> yanitUret(String soru);
}
