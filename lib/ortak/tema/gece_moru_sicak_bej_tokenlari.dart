import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ortak/tema/tema_tokenlari.dart';

class GeceMoruSicakBejTemaTokenlari implements TemaTokenlari {
  const GeceMoruSicakBejTemaTokenlari();

  @override
  Color get birincilAksiyon => AnaSayfaRenkSablonu.birincilAksiyon;

  @override
  Color get ikincilAksiyon => AnaSayfaRenkSablonu.ikincilAksiyon;

  @override
  Color get vurguAksiyon => AnaSayfaRenkSablonu.ucunculAksiyon;

  @override
  Color get anaArkaPlan => AnaSayfaRenkSablonu.arkaPlanKoyu;

  @override
  Color get anaArkaPlanIkincil => AnaSayfaRenkSablonu.arkaPlanOrta;

  @override
  Color get anaArkaPlanUcuncul => AnaSayfaRenkSablonu.arkaPlanUst;

  @override
  Color get popupYuzey => AnaSayfaRenkSablonu.panelKoyu;

  @override
  Color get popupAltYuzey => AnaSayfaRenkSablonu.panelYuksek;

  @override
  Color get kartYuzey => AnaSayfaRenkSablonu.panelKoyu;

  @override
  Color get inceKenar => AnaSayfaRenkSablonu.cerceve;

  @override
  Color get metinBirincilKoyu => AnaSayfaRenkSablonu.metinAna;

  @override
  Color get metinIkincilKoyu => AnaSayfaRenkSablonu.metinIkincil;

  @override
  Color get metinBirincilAcik => AnaSayfaRenkSablonu.metinAna;

  @override
  Color get metinIkincilAcik => AnaSayfaRenkSablonu.metinIkincil;

  @override
  Color get suruklemeTutamaci => Colors.white.withValues(alpha: 0.5);

  @override
  String get govdeYaziAilesi => 'Trebuchet MS';

  @override
  String get baslikYaziAilesi => 'Georgia';

  @override
  Size get dokunmatikHedefBoyutu => const Size(56, 56);
}
