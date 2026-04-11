import 'package:restoran_app/ozellikler/rezervasyon/alan/enumlar/rezervasyon_durumu.dart';

class RezervasyonVarligi {
  const RezervasyonVarligi({
    required this.id,
    required this.musteriAdi,
    required this.telefon,
    required this.kisiSayisi,
    required this.baslangicZamani,
    required this.bitisZamani,
    required this.durum,
    required this.olusturmaZamani,
    this.bolumId,
    this.bolumAdi,
    this.masaId,
    this.masaAdi,
    this.notMetni = '',
  });

  final String id;
  final String musteriAdi;
  final String telefon;
  final int kisiSayisi;
  final DateTime baslangicZamani;
  final DateTime bitisZamani;
  final RezervasyonDurumu durum;
  final DateTime olusturmaZamani;
  final String? bolumId;
  final String? bolumAdi;
  final String? masaId;
  final String? masaAdi;
  final String notMetni;

  bool zamanAraligiCakisiyor({
    required DateTime baslangic,
    required DateTime bitis,
  }) {
    return baslangicZamani.isBefore(bitis) && bitisZamani.isAfter(baslangic);
  }

  RezervasyonVarligi copyWith({
    String? id,
    String? musteriAdi,
    String? telefon,
    int? kisiSayisi,
    DateTime? baslangicZamani,
    DateTime? bitisZamani,
    RezervasyonDurumu? durum,
    DateTime? olusturmaZamani,
    String? bolumId,
    String? bolumAdi,
    String? masaId,
    String? masaAdi,
    String? notMetni,
  }) {
    return RezervasyonVarligi(
      id: id ?? this.id,
      musteriAdi: musteriAdi ?? this.musteriAdi,
      telefon: telefon ?? this.telefon,
      kisiSayisi: kisiSayisi ?? this.kisiSayisi,
      baslangicZamani: baslangicZamani ?? this.baslangicZamani,
      bitisZamani: bitisZamani ?? this.bitisZamani,
      durum: durum ?? this.durum,
      olusturmaZamani: olusturmaZamani ?? this.olusturmaZamani,
      bolumId: bolumId ?? this.bolumId,
      bolumAdi: bolumAdi ?? this.bolumAdi,
      masaId: masaId ?? this.masaId,
      masaAdi: masaAdi ?? this.masaAdi,
      notMetni: notMetni ?? this.notMetni,
    );
  }
}
