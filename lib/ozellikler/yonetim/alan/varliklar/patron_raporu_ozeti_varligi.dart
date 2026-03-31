class PatronRaporuOzetiVarligi {
  const PatronRaporuOzetiVarligi({
    required this.ortalamaAdisyon,
    required this.tahminiGunSonuCiro,
    required this.enGucluKanalEtiketi,
    required this.enGucluKanalAdedi,
    required this.zirveSaatEtiketi,
    required this.zirveSaatAdedi,
    required this.enYuksekSiparisNo,
    required this.enYuksekSiparisTutari,
  });

  final double ortalamaAdisyon;
  final double tahminiGunSonuCiro;
  final String enGucluKanalEtiketi;
  final int enGucluKanalAdedi;
  final String zirveSaatEtiketi;
  final int zirveSaatAdedi;
  final String enYuksekSiparisNo;
  final double enYuksekSiparisTutari;

  String get ozetMetni {
    return '$enGucluKanalEtiketi kanali gun icinde en fazla hacmi getirirken, '
        '$zirveSaatEtiketi zaman araligi operasyon temposunu belirliyor.';
  }
}
