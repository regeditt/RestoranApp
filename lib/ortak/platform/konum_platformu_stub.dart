import 'package:restoran_app/ortak/platform/konum_platformu.dart';

class _KonumPlatformuStub implements KonumPlatformu {
  @override
  Future<KonumHazirlamaSonucu> hazirla() async {
    return const KonumHazirlamaSonucu.hata(
      'Bu platformda canli konum takibi desteklenmiyor.',
    );
  }

  @override
  Future<KonumNoktasi?> anlikKonumGetir() async {
    return null;
  }

  @override
  Stream<KonumNoktasi> konumAkisi() {
    return const Stream<KonumNoktasi>.empty();
  }
}

KonumPlatformu konumPlatformuOlustur() {
  return _KonumPlatformuStub();
}
