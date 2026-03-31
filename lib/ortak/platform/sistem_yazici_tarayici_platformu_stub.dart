import 'package:restoran_app/ortak/platform/sistem_yazici_tarayici_platformu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart';

class _SistemYaziciTarayiciPlatformuStub
    implements SistemYaziciTarayiciPlatformu {
  @override
  Future<List<SistemYaziciAdayiVarligi>> getir() async {
    return const <SistemYaziciAdayiVarligi>[];
  }
}

SistemYaziciTarayiciPlatformu sistemYaziciTarayiciPlatformuOlustur() {
  return _SistemYaziciTarayiciPlatformuStub();
}
