class StokOzetiVarligi {
  const StokOzetiVarligi({
    required this.toplamStokDegeri,
    required this.kritikMalzemeSayisi,
    required this.toplamHammaddeSayisi,
    required this.kritikMalzemeler,
    required this.menuMaliyetleri,
  });

  final double toplamStokDegeri;
  final int kritikMalzemeSayisi;
  final int toplamHammaddeSayisi;
  final List<KritikMalzemeVarligi> kritikMalzemeler;
  final List<MenuMaliyetVarligi> menuMaliyetleri;
}

class KritikMalzemeVarligi {
  const KritikMalzemeVarligi({
    required this.ad,
    required this.kalanMiktarMetni,
  });

  final String ad;
  final String kalanMiktarMetni;
}

class MenuMaliyetVarligi {
  const MenuMaliyetVarligi({
    required this.urunAdi,
    required this.satisFiyati,
    required this.receteMaliyeti,
    required this.karMarjiOrani,
  });

  final String urunAdi;
  final double satisFiyati;
  final double receteMaliyeti;
  final double karMarjiOrani;
}
