class HammaddeStokVarligi {
  const HammaddeStokVarligi({
    required this.id,
    required this.ad,
    required this.birim,
    required this.mevcutMiktar,
    required this.kritikEsik,
    required this.birimMaliyet,
  });

  final String id;
  final String ad;
  final String birim;
  final double mevcutMiktar;
  final double kritikEsik;
  final double birimMaliyet;

  bool get kritikMi => mevcutMiktar <= kritikEsik;

  double get toplamDeger => mevcutMiktar * birimMaliyet;

  HammaddeStokVarligi copyWith({
    String? id,
    String? ad,
    String? birim,
    double? mevcutMiktar,
    double? kritikEsik,
    double? birimMaliyet,
  }) {
    return HammaddeStokVarligi(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      birim: birim ?? this.birim,
      mevcutMiktar: mevcutMiktar ?? this.mevcutMiktar,
      kritikEsik: kritikEsik ?? this.kritikEsik,
      birimMaliyet: birimMaliyet ?? this.birimMaliyet,
    );
  }
}
