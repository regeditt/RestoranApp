class UrunVarligi {
  const UrunVarligi({
    required this.id,
    required this.kategoriId,
    required this.ad,
    required this.aciklama,
    required this.fiyat,
    this.gorselUrl,
    this.stoktaMi = true,
    this.oneCikanMi = false,
  });

  final String id;
  final String kategoriId;
  final String ad;
  final String aciklama;
  final double fiyat;
  final String? gorselUrl;
  final bool stoktaMi;
  final bool oneCikanMi;
}
