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
    required this.uyariEtiketi,
    required this.aciliyetOrani,
  });

  final String ad;
  final String kalanMiktarMetni;
  final String uyariEtiketi;
  final double aciliyetOrani;
}

class MenuMaliyetVarligi {
  const MenuMaliyetVarligi({
    required this.urunAdi,
    required this.satisFiyati,
    required this.receteMaliyeti,
    required this.karMarjiOrani,
    required this.uretilebilirAdet,
  });

  final String urunAdi;
  final double satisFiyati;
  final double receteMaliyeti;
  final double karMarjiOrani;
  final int uretilebilirAdet;
}
