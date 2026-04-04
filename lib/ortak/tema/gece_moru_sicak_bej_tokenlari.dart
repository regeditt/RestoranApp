import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/tema/tema_tokenlari.dart';

class GeceMoruSicakBejTemaTokenlari implements TemaTokenlari {
  const GeceMoruSicakBejTemaTokenlari();

  @override
  Color get birincilAksiyon => const Color(0xFFE57A3D);

  @override
  Color get ikincilAksiyon => const Color(0xFF7B5CFF);

  @override
  Color get vurguAksiyon => const Color(0xFFFF5D8F);

  @override
  Color get anaArkaPlan => const Color(0xFF110D18);

  @override
  Color get anaArkaPlanIkincil => const Color(0xFF1A1324);

  @override
  Color get anaArkaPlanUcuncul => const Color(0xFF2B1B3A);

  @override
  Color get popupYuzey => const Color(0xFFF1EBF3);

  @override
  Color get popupAltYuzey => const Color(0xFFF1EBF3);

  @override
  Color get kartYuzey => const Color(0xFFF1EBF3);

  @override
  Color get inceKenar => const Color(0xFFE3D6CD);

  @override
  Color get metinBirincilKoyu => const Color(0xFF2D2140);

  @override
  Color get metinIkincilKoyu => const Color(0xFF6D6079);

  @override
  Color get metinBirincilAcik => const Color(0xFFF8F3FB);

  @override
  Color get metinIkincilAcik => const Color(0xFFD8CDE3);

  @override
  Color get suruklemeTutamaci => const Color(0x806D6079);

  @override
  String get govdeYaziAilesi => 'Trebuchet MS';

  @override
  String get baslikYaziAilesi => 'Georgia';

  @override
  Size get dokunmatikHedefBoyutu => const Size(56, 56);
}
