import 'package:restoran_app/ortak/platform/cihaz_kimligi_saglayici.dart';

class _CihazKimligiSaglayiciStub implements CihazKimligiSaglayici {
  const _CihazKimligiSaglayiciStub();

  @override
  String cihazKoduGetir() {
    return 'WEB001';
  }
}

CihazKimligiSaglayici cihazKimligiSaglayiciOlustur() {
  return const _CihazKimligiSaglayiciStub();
}
