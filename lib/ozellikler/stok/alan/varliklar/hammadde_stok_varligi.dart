import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';

class HammaddeStokVarligi {
  HammaddeStokVarligi({
    required this.id,
    required this.ad,
    required this.birim,
    required this.mevcutMiktar,
    required this.kritikEsik,
    double? uyariEsigi,
    required this.birimMaliyet,
  }) : uyariEsigi = _uyariEsigiCoz(uyariEsigi, kritikEsik);

  final String id;
  final String ad;
  final String birim;
  final double mevcutMiktar;
  final double kritikEsik;
  final double uyariEsigi;
  final double birimMaliyet;

  bool get kritikMi => uyariDurumu == StokUyariDurumu.kritik;

  bool get uyariMi => uyariDurumu == StokUyariDurumu.uyari;

  bool get tukendiMi => uyariDurumu == StokUyariDurumu.tukendi;

  StokUyariDurumu get uyariDurumu {
    if (mevcutMiktar <= 0) {
      return StokUyariDurumu.tukendi;
    }
    if (mevcutMiktar <= kritikEsik) {
      return StokUyariDurumu.kritik;
    }
    if (mevcutMiktar <= uyariEsigi) {
      return StokUyariDurumu.uyari;
    }
    return StokUyariDurumu.normal;
  }

  double get toplamDeger => mevcutMiktar * birimMaliyet;

  HammaddeStokVarligi copyWith({
    String? id,
    String? ad,
    String? birim,
    double? mevcutMiktar,
    double? kritikEsik,
    double? uyariEsigi,
    double? birimMaliyet,
  }) {
    return HammaddeStokVarligi(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      birim: birim ?? this.birim,
      mevcutMiktar: mevcutMiktar ?? this.mevcutMiktar,
      kritikEsik: kritikEsik ?? this.kritikEsik,
      uyariEsigi: uyariEsigi ?? this.uyariEsigi,
      birimMaliyet: birimMaliyet ?? this.birimMaliyet,
    );
  }

  static double _uyariEsigiCoz(double? uyariEsigi, double kritikEsik) {
    final double varsayilan = kritikEsik <= 0 ? 0 : kritikEsik * 1.35;
    final double deger = uyariEsigi ?? varsayilan;
    if (deger < kritikEsik) {
      return kritikEsik;
    }
    return deger;
  }
}
