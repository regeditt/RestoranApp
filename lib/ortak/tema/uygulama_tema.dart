import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/tema/gece_moru_sicak_bej_tokenlari.dart';
import 'package:restoran_app/ortak/tema/tema_tokenlari.dart';
import 'package:restoran_app/ortak/tema/uygulama_tema_olusturucu.dart';

class UygulamaTema {
  const UygulamaTema._();

  static const TemaTokenlari _temaTokenlari = GeceMoruSicakBejTemaTokenlari();

  static ThemeData get acikTema =>
      const UygulamaTemaOlusturucu(temaTokenlari: _temaTokenlari).olustur();
}
