import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

class SepetKalemiVarligi {
  const SepetKalemiVarligi({
    required this.id,
    required this.urun,
    required this.birimFiyat,
    required this.adet,
    this.secenekAdi,
    this.notMetni,
  });

  final String id;
  final UrunVarligi urun;
  final double birimFiyat;
  final int adet;
  final String? secenekAdi;
  final String? notMetni;

  double get araToplam => birimFiyat * adet;
}
