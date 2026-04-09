import 'konum_platformu_stub.dart'
    if (dart.library.io) 'konum_platformu_io.dart';

class KonumNoktasi {
  const KonumNoktasi({
    required this.enlem,
    required this.boylam,
    required this.olusturmaTarihi,
  });

  final double enlem;
  final double boylam;
  final DateTime olusturmaTarihi;
}

class KonumHazirlamaSonucu {
  const KonumHazirlamaSonucu.basarili([this.mesaj = '']) : basarili = true;

  const KonumHazirlamaSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

abstract class KonumPlatformu {
  Future<KonumHazirlamaSonucu> hazirla();

  Future<KonumNoktasi?> anlikKonumGetir();

  Stream<KonumNoktasi> konumAkisi();
}

final KonumPlatformu konumPlatformu = konumPlatformuOlustur();
