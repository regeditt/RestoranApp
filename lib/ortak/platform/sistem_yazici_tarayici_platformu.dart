import 'sistem_yazici_tarayici_platformu_stub.dart'
    if (dart.library.io) 'sistem_yazici_tarayici_platformu_io.dart';

import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart';

abstract class SistemYaziciTarayiciPlatformu {
  Future<List<SistemYaziciAdayiVarligi>> getir();
}

final SistemYaziciTarayiciPlatformu sistemYaziciTarayiciPlatformu =
    sistemYaziciTarayiciPlatformuOlustur();
