import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';

class SepetVarligi {
  const SepetVarligi({
    required this.id,
    required this.kalemler,
    this.kuponKodu,
  });

  final String id;
  final List<SepetKalemiVarligi> kalemler;
  final String? kuponKodu;

  int get toplamUrunAdedi =>
      kalemler.fold<int>(0, (toplam, kalem) => toplam + kalem.adet);

  double get araToplam =>
      kalemler.fold<double>(0, (toplam, kalem) => toplam + kalem.araToplam);
}
