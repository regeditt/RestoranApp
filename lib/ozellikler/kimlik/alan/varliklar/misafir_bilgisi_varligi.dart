class MisafirBilgisiVarligi {
  const MisafirBilgisiVarligi({
    required this.adSoyad,
    required this.telefon,
    this.eposta,
    this.adres,
  });

  final String adSoyad;
  final String telefon;
  final String? eposta;
  final String? adres;
}
