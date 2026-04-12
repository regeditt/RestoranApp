import 'package:restoran_app/ozellikler/odeme_kasa/alan/enumlar/odeme_yontemi.dart';

class KasaHareketiVarligi {
  const KasaHareketiVarligi({
    required this.id,
    required this.zaman,
    required this.baslik,
    required this.detay,
    required this.tutar,
    required this.odemeYontemi,
    required this.tahsilatMi,
  });

  final String id;
  final DateTime zaman;
  final String baslik;
  final String detay;
  final double tutar;
  final OdemeYontemi odemeYontemi;
  final bool tahsilatMi;
}
