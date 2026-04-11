class LisansDurumuVarligi {
  const LisansDurumuVarligi({
    required this.aktifMi,
    required this.mesaj,
    required this.denemeMi,
    this.anahtar,
    this.gecerlilikTarihi,
    this.cihazKodu,
    this.denemeBitisTarihi,
    this.kalanDenemeGunu,
  });

  const LisansDurumuVarligi.pasif(
    String mesaj, {
    String? cihazKodu,
    DateTime? denemeBitisTarihi,
    int? kalanDenemeGunu,
  }) : this(
         aktifMi: false,
         mesaj: mesaj,
         denemeMi: false,
         cihazKodu: cihazKodu,
         denemeBitisTarihi: denemeBitisTarihi,
         kalanDenemeGunu: kalanDenemeGunu,
       );

  const LisansDurumuVarligi.aktifLisansli({
    required String mesaj,
    required String anahtar,
    required DateTime gecerlilikTarihi,
    required String cihazKodu,
  }) : this(
         aktifMi: true,
         mesaj: mesaj,
         denemeMi: false,
         anahtar: anahtar,
         gecerlilikTarihi: gecerlilikTarihi,
         cihazKodu: cihazKodu,
       );

  const LisansDurumuVarligi.aktifDeneme({
    required String mesaj,
    required String cihazKodu,
    required DateTime denemeBitisTarihi,
    required int kalanDenemeGunu,
  }) : this(
         aktifMi: true,
         mesaj: mesaj,
         denemeMi: true,
         cihazKodu: cihazKodu,
         denemeBitisTarihi: denemeBitisTarihi,
         kalanDenemeGunu: kalanDenemeGunu,
       );

  final bool aktifMi;
  final String mesaj;
  final bool denemeMi;
  final String? anahtar;
  final DateTime? gecerlilikTarihi;
  final String? cihazKodu;
  final DateTime? denemeBitisTarihi;
  final int? kalanDenemeGunu;
}
