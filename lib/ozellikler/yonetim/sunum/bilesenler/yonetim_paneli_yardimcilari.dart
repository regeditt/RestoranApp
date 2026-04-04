import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

String durumEtiketi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return 'Yeni';
    case SiparisDurumu.hazirlaniyor:
      return 'Hazirlaniyor';
    case SiparisDurumu.hazir:
      return 'Hazir';
    case SiparisDurumu.yolda:
      return 'Yolda';
    case SiparisDurumu.teslimEdildi:
      return 'Teslim edildi';
    case SiparisDurumu.iptalEdildi:
      return 'Iptal';
  }
}

String siparisAltEtiketi(SiparisVarligi siparis) {
  final String masa = siparis.masaNo ?? '';
  final String bolum = siparis.bolumAdi ?? '';
  final String sahip =
      siparis.sahip.kullanici?.adSoyad ??
      siparis.sahip.misafirBilgisi?.adSoyad ??
      '';
  final List<String> parcalar = <String>[];
  if (masa.isNotEmpty) {
    parcalar.add('Masa $masa');
  }
  if (bolum.isNotEmpty) {
    parcalar.add(bolum);
  }
  if (sahip.isNotEmpty) {
    parcalar.add(sahip);
  }
  return parcalar.isEmpty ? 'Siparis detayi' : parcalar.join(' · ');
}

Color durumRengi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return const Color(0xFF7A4DFF);
    case SiparisDurumu.hazirlaniyor:
      return const Color(0xFFFFB84C);
    case SiparisDurumu.hazir:
      return const Color(0xFF32D783);
    case SiparisDurumu.yolda:
      return const Color(0xFF3AA9FF);
    case SiparisDurumu.teslimEdildi:
      return const Color(0xFF6C7BFF);
    case SiparisDurumu.iptalEdildi:
      return const Color(0xFFFF6B6B);
  }
}

int durumOnceligi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return 1;
    case SiparisDurumu.hazirlaniyor:
      return 2;
    case SiparisDurumu.hazir:
      return 3;
    case SiparisDurumu.yolda:
      return 4;
    case SiparisDurumu.teslimEdildi:
      return 5;
    case SiparisDurumu.iptalEdildi:
      return 6;
  }
}

String paraYaz(double tutar) {
  return '${tutar.toStringAsFixed(2)} ₺';
}
