import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_backend_ayar_varligi.dart';

abstract class AsistanBackendAyarDeposu {
  Future<AsistanBackendAyarVarligi?> yukle();

  Future<void> kaydet(AsistanBackendAyarVarligi ayar);
}

class AsistanBackendAyarDeposuBellek implements AsistanBackendAyarDeposu {
  AsistanBackendAyarVarligi? _ayar;

  @override
  Future<void> kaydet(AsistanBackendAyarVarligi ayar) async {
    _ayar = ayar;
  }

  @override
  Future<AsistanBackendAyarVarligi?> yukle() async {
    return _ayar;
  }
}
