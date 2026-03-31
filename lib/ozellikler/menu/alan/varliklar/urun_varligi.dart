import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_secenegi_varligi.dart';

class UrunVarligi {
  const UrunVarligi({
    required this.id,
    required this.kategoriId,
    required this.ad,
    required this.aciklama,
    required this.fiyat,
    this.gorselUrl,
    this.stoktaMi = true,
    this.oneCikanMi = false,
    this.secenekler = const <UrunSecenegiVarligi>[],
  });

  final String id;
  final String kategoriId;
  final String ad;
  final String aciklama;
  final double fiyat;
  final String? gorselUrl;
  final bool stoktaMi;
  final bool oneCikanMi;
  final List<UrunSecenegiVarligi> secenekler;

  UrunVarligi copyWith({
    String? id,
    String? kategoriId,
    String? ad,
    String? aciklama,
    double? fiyat,
    String? gorselUrl,
    bool? stoktaMi,
    bool? oneCikanMi,
    List<UrunSecenegiVarligi>? secenekler,
  }) {
    return UrunVarligi(
      id: id ?? this.id,
      kategoriId: kategoriId ?? this.kategoriId,
      ad: ad ?? this.ad,
      aciklama: aciklama ?? this.aciklama,
      fiyat: fiyat ?? this.fiyat,
      gorselUrl: gorselUrl ?? this.gorselUrl,
      stoktaMi: stoktaMi ?? this.stoktaMi,
      oneCikanMi: oneCikanMi ?? this.oneCikanMi,
      secenekler: secenekler ?? this.secenekler,
    );
  }

  UrunSecenegiVarligi? get varsayilanSecenek {
    if (secenekler.isEmpty) {
      return null;
    }

    for (final UrunSecenegiVarligi secenek in secenekler) {
      if (secenek.varsayilanMi) {
        return secenek;
      }
    }

    return secenekler.first;
  }
}
