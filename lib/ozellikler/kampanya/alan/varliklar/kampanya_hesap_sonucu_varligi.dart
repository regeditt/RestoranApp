class KampanyaHesapSonucuVarligi {
  const KampanyaHesapSonucuVarligi({
    required this.uygulandiMi,
    required this.kuponKodu,
    required this.indirimTutari,
    required this.aciklama,
    this.hataMesaji,
  });

  final bool uygulandiMi;
  final String? kuponKodu;
  final double indirimTutari;
  final String aciklama;
  final String? hataMesaji;

  static const KampanyaHesapSonucuVarligi bos = KampanyaHesapSonucuVarligi(
    uygulandiMi: false,
    kuponKodu: null,
    indirimTutari: 0,
    aciklama: 'Kupon uygulanmadi',
    hataMesaji: null,
  );
}
