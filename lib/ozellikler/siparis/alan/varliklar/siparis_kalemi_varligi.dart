class SiparisKalemiVarligi {
  const SiparisKalemiVarligi({
    required this.id,
    required this.urunId,
    required this.urunAdi,
    required this.birimFiyat,
    required this.adet,
    this.notMetni,
  });

  final String id;
  final String urunId;
  final String urunAdi;
  final double birimFiyat;
  final int adet;
  final String? notMetni;

  double get araToplam => birimFiyat * adet;
}
