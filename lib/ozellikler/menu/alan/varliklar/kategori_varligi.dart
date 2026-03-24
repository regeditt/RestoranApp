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
}
