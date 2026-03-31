class KategoriVarligi {
  const KategoriVarligi({
    required this.id,
    required this.ad,
    required this.sira,
    this.acikMi = true,
  });

  final String id;
  final String ad;
  final int sira;
  final bool acikMi;

  KategoriVarligi copyWith({String? id, String? ad, int? sira, bool? acikMi}) {
    return KategoriVarligi(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      sira: sira ?? this.sira,
      acikMi: acikMi ?? this.acikMi,
    );
  }
}
