import 'package:flutter/material.dart';

enum YaziciBaglantiDurumu { bagli, dikkat, kapali }

class YaziciDurumuVarligi {
  const YaziciDurumuVarligi({
    required this.id,
    required this.ad,
    required this.rolEtiketi,
    required this.baglantiNoktasi,
    required this.aciklama,
    required this.durum,
  });

  final String id;
  final String ad;
  final String rolEtiketi;
  final String baglantiNoktasi;
  final String aciklama;
  final YaziciBaglantiDurumu durum;

  YaziciDurumuVarligi copyWith({
    String? id,
    String? ad,
    String? rolEtiketi,
    String? baglantiNoktasi,
    String? aciklama,
    YaziciBaglantiDurumu? durum,
  }) {
    return YaziciDurumuVarligi(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      rolEtiketi: rolEtiketi ?? this.rolEtiketi,
      baglantiNoktasi: baglantiNoktasi ?? this.baglantiNoktasi,
      aciklama: aciklama ?? this.aciklama,
      durum: durum ?? this.durum,
    );
  }

  String get durumEtiketi {
    switch (durum) {
      case YaziciBaglantiDurumu.bagli:
        return 'Bagli';
      case YaziciBaglantiDurumu.dikkat:
        return 'Dikkat';
      case YaziciBaglantiDurumu.kapali:
        return 'Kapali';
    }
  }

  Color get renk {
    switch (durum) {
      case YaziciBaglantiDurumu.bagli:
        return const Color(0xFF69E2A5);
      case YaziciBaglantiDurumu.dikkat:
        return const Color(0xFFFFC857);
      case YaziciBaglantiDurumu.kapali:
        return const Color(0xFFFF8A8A);
    }
  }
}
