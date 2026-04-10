/// Lisans anahtari dogrulamasinin durumunu, mesajini ve gecerlilik bilgisini tasir.
class LisansAnahtariDogrulamaSonucu {
  const LisansAnahtariDogrulamaSonucu._({
    required this.gecerliMi,
    required this.mesaj,
    this.duzenlenmisAnahtar,
    this.gecerlilikTarihi,
  });

  const LisansAnahtariDogrulamaSonucu.basarili({
    required String duzenlenmisAnahtar,
    required DateTime gecerlilikTarihi,
  }) : this._(
         gecerliMi: true,
         mesaj: 'Lisans dogrulandi.',
         duzenlenmisAnahtar: duzenlenmisAnahtar,
         gecerlilikTarihi: gecerlilikTarihi,
       );

  const LisansAnahtariDogrulamaSonucu.hata(String mesaj)
    : this._(gecerliMi: false, mesaj: mesaj);

  final bool gecerliMi;
  final String mesaj;
  final String? duzenlenmisAnahtar;
  final DateTime? gecerlilikTarihi;
}

/// Lisans anahtarinin format, imza ve son gecerlilik tarihini dogrular.
class LisansAnahtariDogrulayici {
  const LisansAnahtariDogrulayici();

  static final RegExp _lisansDeseni = RegExp(r'^RST-(\d{8})-([A-Z0-9]{6})$');

  LisansAnahtariDogrulamaSonucu dogrula(
    String girilenAnahtar, {
    DateTime? simdi,
  }) {
    final String duzenlenmis = girilenAnahtar.trim().toUpperCase();
    if (duzenlenmis.isEmpty) {
      return const LisansAnahtariDogrulamaSonucu.hata(
        'Lisans anahtari bos olamaz.',
      );
    }

    final Match? eslesme = _lisansDeseni.firstMatch(duzenlenmis);
    if (eslesme == null) {
      return const LisansAnahtariDogrulamaSonucu.hata(
        'Lisans formati gecersiz. Beklenen: RST-YYYYMMDD-XXXXXX',
      );
    }

    final String tarihBileseni = eslesme.group(1)!;
    final DateTime? gecerlilikTarihi = _tarihCoz(tarihBileseni);
    if (gecerlilikTarihi == null) {
      return const LisansAnahtariDogrulamaSonucu.hata(
        'Lisans anahtarindaki tarih gecersiz.',
      );
    }

    final String beklenenImza = _imzaUret(tarihBileseni);
    final String gelenImza = eslesme.group(2)!;
    if (beklenenImza != gelenImza) {
      return const LisansAnahtariDogrulamaSonucu.hata(
        'Lisans imzasi gecersiz.',
      );
    }

    final DateTime kontrolZamani = simdi ?? DateTime.now();
    final DateTime sonKullanma = DateTime(
      gecerlilikTarihi.year,
      gecerlilikTarihi.month,
      gecerlilikTarihi.day,
      23,
      59,
      59,
    );
    if (kontrolZamani.isAfter(sonKullanma)) {
      return const LisansAnahtariDogrulamaSonucu.hata('Lisans suresi dolmus.');
    }

    return LisansAnahtariDogrulamaSonucu.basarili(
      duzenlenmisAnahtar: duzenlenmis,
      gecerlilikTarihi: gecerlilikTarihi,
    );
  }

  String lisansAnahtariOlustur(DateTime gecerlilikTarihi) {
    final String tarihBileseni =
        '${gecerlilikTarihi.year.toString().padLeft(4, '0')}'
        '${gecerlilikTarihi.month.toString().padLeft(2, '0')}'
        '${gecerlilikTarihi.day.toString().padLeft(2, '0')}';
    return 'RST-$tarihBileseni-${_imzaUret(tarihBileseni)}';
  }

  DateTime? _tarihCoz(String tarihBileseni) {
    final int? yil = int.tryParse(tarihBileseni.substring(0, 4));
    final int? ay = int.tryParse(tarihBileseni.substring(4, 6));
    final int? gun = int.tryParse(tarihBileseni.substring(6, 8));
    if (yil == null || ay == null || gun == null) {
      return null;
    }
    if (ay < 1 || ay > 12 || gun < 1 || gun > 31) {
      return null;
    }
    final DateTime tarih = DateTime(yil, ay, gun);
    if (tarih.year != yil || tarih.month != ay || tarih.day != gun) {
      return null;
    }
    return tarih;
  }

  String _imzaUret(String tarihBileseni) {
    const String tohum = 'RESTORANAPP-LISANS-V1';
    final String veri = '$tarihBileseni|$tohum';
    int deger = 17;
    for (final int karakter in veri.codeUnits) {
      deger = ((deger * 33) ^ karakter) % 2176782336;
    }
    return deger.toRadixString(36).padLeft(6, '0').toUpperCase();
  }
}
