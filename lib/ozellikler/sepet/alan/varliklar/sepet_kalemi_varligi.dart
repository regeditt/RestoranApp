import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

class SepetKalemiVarligi {
  const SepetKalemiVarligi({
    required this.id,
    required this.urun,
    required this.adet,
    this.notMetni,
  });

  final String id;
  final UrunVarligi urun;
  final int adet;
  final String? notMetni;

  double get araToplam => urun.fiyat * adet;
}
