class UrunSecenegiVarligi {
  const UrunSecenegiVarligi({
    required this.id,
    required this.ad,
    this.fiyatFarki = 0,
    this.varsayilanMi = false,
  });

  final String id;
  final String ad;
  final double fiyatFarki;
  final bool varsayilanMi;
}
