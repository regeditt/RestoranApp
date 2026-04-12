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

/// Lisans anahtarinin format, imza, cihaz ve son gecerlilik tarihini dogrular.
class LisansAnahtariDogrulayici {
  const LisansAnahtariDogrulayici();

  static final RegExp _lisansDeseni = RegExp(
    r'^VP-(\d{8})-([A-Z0-9]{6})-([A-Z0-9]{6})$',
  );
  static final RegExp _cihazKoduDeseni = RegExp(r'^[A-Z0-9]{6}$');

  LisansAnahtariDogrulamaSonucu dogrula(
    String girilenAnahtar, {
    required String cihazKodu,
    DateTime? simdi,
  }) {
    final String duzenlenmis = girilenAnahtar.trim().toUpperCase();
    if (duzenlenmis.isEmpty) {
      return const LisansAnahtariDogrulamaSonucu.hata(
        'Lisans anahtari bos olamaz.',
      );
    }

    final String duzenlenmisCihazKodu = _cihazKoduDuzenle(cihazKodu);
    if (!_cihazKoduDeseni.hasMatch(duzenlenmisCihazKodu)) {
      return const LisansAnahtariDogrulamaSonucu.hata('Cihaz kodu gecersiz.');
    }

    final Match? eslesme = _lisansDeseni.firstMatch(duzenlenmis);
    if (eslesme == null) {
      return const LisansAnahtariDogrulamaSonucu.hata(
        'Lisans formati gecersiz. Beklenen: VP-YYYYMMDD-CCCCCC-XXXXXX',
      );
    }

    final String tarihBileseni = eslesme.group(1)!;
    final String lisansCihazKodu = eslesme.group(2)!;
    if (lisansCihazKodu != duzenlenmisCihazKodu) {
      return const LisansAnahtariDogrulamaSonucu.hata(
        'Bu lisans farkli bir cihaza ait.',
      );
    }

    final DateTime? gecerlilikTarihi = _tarihCoz(tarihBileseni);
    if (gecerlilikTarihi == null) {
      return const LisansAnahtariDogrulamaSonucu.hata(
        'Lisans anahtarindaki tarih gecersiz.',
      );
    }

    final String beklenenImza = _imzaUret(tarihBileseni, lisansCihazKodu);
    final String gelenImza = eslesme.group(3)!;
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

  String lisansAnahtariOlustur(
    DateTime gecerlilikTarihi, {
    required String cihazKodu,
  }) {
    final String duzenlenmisCihazKodu = _cihazKoduDuzenle(cihazKodu);
    if (!_cihazKoduDeseni.hasMatch(duzenlenmisCihazKodu)) {
      throw ArgumentError.value(
        cihazKodu,
        'cihazKodu',
        'Cihaz kodu 6 karakterli A-Z ve 0-9 olmali.',
      );
    }

    final String tarihBileseni =
        '${gecerlilikTarihi.year.toString().padLeft(4, '0')}'
        '${gecerlilikTarihi.month.toString().padLeft(2, '0')}'
        '${gecerlilikTarihi.day.toString().padLeft(2, '0')}';
    return 'VP-$tarihBileseni-$duzenlenmisCihazKodu-'
        '${_imzaUret(tarihBileseni, duzenlenmisCihazKodu)}';
  }

  String cihazKoduDuzenle(String girilen) {
    return _cihazKoduDuzenle(girilen);
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

  String _imzaUret(String tarihBileseni, String cihazKodu) {
    const String tohum = 'VECTORPOS-LISANS-V2';
    final String veri = '$tarihBileseni|$cihazKodu|$tohum';
    int deger = 17;
    for (final int karakter in veri.codeUnits) {
      deger = ((deger * 33) ^ karakter) % 2176782336;
    }
    return deger.toRadixString(36).padLeft(6, '0').toUpperCase();
  }

  String _cihazKoduDuzenle(String girilen) {
    final String sade = girilen.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return sade.trim().toUpperCase();
  }
}
