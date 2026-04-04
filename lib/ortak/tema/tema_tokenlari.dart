import 'package:flutter/material.dart';

abstract class TemaTokenlari {
  const TemaTokenlari();

  Color get birincilAksiyon;
  Color get ikincilAksiyon;
  Color get vurguAksiyon;

  Color get anaArkaPlan;
  Color get anaArkaPlanIkincil;
  Color get anaArkaPlanUcuncul;

  Color get popupYuzey;
  Color get popupAltYuzey;
  Color get kartYuzey;
  Color get inceKenar;

  Color get metinBirincilKoyu;
  Color get metinIkincilKoyu;
  Color get metinBirincilAcik;
  Color get metinIkincilAcik;

  Color get suruklemeTutamaci;

  String get govdeYaziAilesi;
  String get baslikYaziAilesi;
  Size get dokunmatikHedefBoyutu;
}
