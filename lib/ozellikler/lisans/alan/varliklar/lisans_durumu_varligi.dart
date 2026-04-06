class LisansDurumuVarligi {
  const LisansDurumuVarligi({
    required this.aktifMi,
    required this.mesaj,
    this.anahtar,
    this.gecerlilikTarihi,
  });

  const LisansDurumuVarligi.pasif(String mesaj)
    : this(aktifMi: false, mesaj: mesaj);

  const LisansDurumuVarligi.aktif({
    required String mesaj,
    required String anahtar,
    required DateTime gecerlilikTarihi,
  }) : this(
         aktifMi: true,
         mesaj: mesaj,
         anahtar: anahtar,
         gecerlilikTarihi: gecerlilikTarihi,
       );

  final bool aktifMi;
  final String mesaj;
  final String? anahtar;
  final DateTime? gecerlilikTarihi;
}
