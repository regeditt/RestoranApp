import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
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
    this.teslimatNotu,
    this.kuryeAdi,
    this.paketTeslimatDurumu,
    this.masaNo,
    this.bolumAdi,
    this.kaynak,
    this.kuponKodu,
    this.indirimTutari = 0,
  });

  final String id;
  final String siparisNo;
  final SiparisSahibiVarligi sahip;
  final TeslimatTipi teslimatTipi;
  final SiparisDurumu durum;
  final List<SiparisKalemiVarligi> kalemler;
  final DateTime olusturmaTarihi;
  final String? adresMetni;
  final String? teslimatNotu;
  final String? kuryeAdi;
  final PaketTeslimatDurumu? paketTeslimatDurumu;
  final String? masaNo;
  final String? bolumAdi;
  final String? kaynak;
  final String? kuponKodu;
  final double indirimTutari;

  double get araToplam =>
      kalemler.fold<double>(0, (toplam, kalem) => toplam + kalem.araToplam);

  double get toplamTutar =>
      (araToplam - indirimTutari).clamp(0, double.infinity).toDouble();

  SiparisVarligi copyWith({
    String? id,
    String? siparisNo,
    SiparisSahibiVarligi? sahip,
    TeslimatTipi? teslimatTipi,
    SiparisDurumu? durum,
    List<SiparisKalemiVarligi>? kalemler,
    DateTime? olusturmaTarihi,
    String? adresMetni,
    String? teslimatNotu,
    String? kuryeAdi,
    PaketTeslimatDurumu? paketTeslimatDurumu,
    String? masaNo,
    String? bolumAdi,
    String? kaynak,
    String? kuponKodu,
    double? indirimTutari,
  }) {
    return SiparisVarligi(
      id: id ?? this.id,
      siparisNo: siparisNo ?? this.siparisNo,
      sahip: sahip ?? this.sahip,
      teslimatTipi: teslimatTipi ?? this.teslimatTipi,
      durum: durum ?? this.durum,
      kalemler: kalemler ?? this.kalemler,
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
      adresMetni: adresMetni ?? this.adresMetni,
      teslimatNotu: teslimatNotu ?? this.teslimatNotu,
      kuryeAdi: kuryeAdi ?? this.kuryeAdi,
      paketTeslimatDurumu: paketTeslimatDurumu ?? this.paketTeslimatDurumu,
      masaNo: masaNo ?? this.masaNo,
      bolumAdi: bolumAdi ?? this.bolumAdi,
      kaynak: kaynak ?? this.kaynak,
      kuponKodu: kuponKodu ?? this.kuponKodu,
      indirimTutari: indirimTutari ?? this.indirimTutari,
    );
  }
}
