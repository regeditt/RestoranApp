abstract class AsistanApiIstemcisi {
  Future<bool> baglantiTestEt(String tabanUrl, {String apiAnahtari = ''});

  Future<String?> yanitIste({
    required String tabanUrl,
    required String soru,
    String apiAnahtari = '',
  });
}
