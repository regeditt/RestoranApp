import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_hareketi_varligi.dart';

class KasaOzetiVarligi {
  const KasaOzetiVarligi({
    required this.nakitToplam,
    required this.kartToplam,
    required this.temassizToplam,
    required this.onlineToplam,
    required this.toplamTahsilat,
    required this.toplamIade,
    required this.kasaBakiye,
    required this.sonHareketler,
  });

  final double nakitToplam;
  final double kartToplam;
  final double temassizToplam;
  final double onlineToplam;
  final double toplamTahsilat;
  final double toplamIade;
  final double kasaBakiye;
  final List<KasaHareketiVarligi> sonHareketler;
}
