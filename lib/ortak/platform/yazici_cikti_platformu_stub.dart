import 'package:restoran_app/ortak/platform/yazici_cikti_platformu.dart';

class _YaziciCiktiPlatformuStub implements YaziciCiktiPlatformu {
  @override
  Future<bool> gonder({
    required String yaziciAdi,
    required String icerik,
  }) async {
    return false;
  }
}

YaziciCiktiPlatformu yaziciCiktiPlatformuOlustur() {
  return _YaziciCiktiPlatformuStub();
}
