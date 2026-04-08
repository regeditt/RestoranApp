import 'package:flutter/material.dart';

enum PersonelDurumu { aktif, mola, pasif }

class PersonelDurumuVarligi {
  const PersonelDurumuVarligi({
    this.kimlik = '',
    required this.adSoyad,
    required this.rolEtiketi,
    required this.bolge,
    required this.aciklama,
    required this.durum,
  });

  final String kimlik;
  final String adSoyad;
  final String rolEtiketi;
  final String bolge;
  final String aciklama;
  final PersonelDurumu durum;

  bool get silinebilirMi => kimlik.isNotEmpty;

  String get kisaAd {
    final List<String> parcalar = adSoyad.split(' ');
    if (parcalar.length == 1) {
      return parcalar.first.substring(0, 1).toUpperCase();
    }
    return '${parcalar.first.substring(0, 1)}${parcalar.last.substring(0, 1)}'
        .toUpperCase();
  }

  String get durumEtiketi {
    switch (durum) {
      case PersonelDurumu.aktif:
        return 'Aktif';
      case PersonelDurumu.mola:
        return 'Molada';
      case PersonelDurumu.pasif:
        return 'Pasif';
    }
  }

  Color get renk {
    switch (durum) {
      case PersonelDurumu.aktif:
        return const Color(0xFF30C48D);
      case PersonelDurumu.mola:
        return const Color(0xFFFF9F43);
      case PersonelDurumu.pasif:
        return const Color(0xFF9AA5B1);
    }
  }
}
