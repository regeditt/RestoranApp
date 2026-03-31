import 'yazici_cikti_platformu_stub.dart'
    if (dart.library.io) 'yazici_cikti_platformu_io.dart';

abstract class YaziciCiktiPlatformu {
  Future<bool> gonder({required String yaziciAdi, required String icerik});
}

final YaziciCiktiPlatformu yaziciCiktiPlatformu = yaziciCiktiPlatformuOlustur();
