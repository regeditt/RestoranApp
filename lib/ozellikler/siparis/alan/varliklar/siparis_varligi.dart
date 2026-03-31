import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';

class SiparisVarligi {
  const SiparisVarligi({
    required this.id,
    required this.siparisNo,
    required this.sahip,
    required this.teslimatTipi,
    required this.durum,
    required this.kalemler,
    required this.olusturmaTarihi,
    this.adresMetni,
    this.masaNo,
    this.bolumAdi,
    this.kaynak,
  });

  final String id;
  final String siparisNo;
  final SiparisSahibiVarligi sahip;
  final TeslimatTipi teslimatTipi;
  final SiparisDurumu durum;
  final List<SiparisKalemiVarligi> kalemler;
  final DateTime olusturmaTarihi;
  final String? adresMetni;
  final String? masaNo;
  final String? bolumAdi;
  final String? kaynak;

  double get toplamTutar =>
      kalemler.fold<double>(0, (toplam, kalem) => toplam + kalem.araToplam);
}
