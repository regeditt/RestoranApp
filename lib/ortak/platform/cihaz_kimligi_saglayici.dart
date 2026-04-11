import 'cihaz_kimligi_saglayici_stub.dart'
    if (dart.library.io) 'cihaz_kimligi_saglayici_io.dart';

abstract class CihazKimligiSaglayici {
  String cihazKoduGetir();
}

final CihazKimligiSaglayici cihazKimligiSaglayici =
    cihazKimligiSaglayiciOlustur();
