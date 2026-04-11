import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';

@immutable
class RestoranTemaRenkleri extends ThemeExtension<RestoranTemaRenkleri> {
  const RestoranTemaRenkleri({
    required this.anaArkaPlan,
    required this.anaArkaPlanIkincil,
    required this.anaArkaPlanUcuncul,
    required this.popupYuzey,
    required this.popupAltYuzey,
    required this.kartYuzey,
    required this.inceKenar,
    required this.metinBirincilKoyu,
    required this.metinIkincilKoyu,
    required this.metinBirincilAcik,
    required this.metinIkincilAcik,
    required this.suruklemeTutamaci,
  });

  final Color anaArkaPlan;
  final Color anaArkaPlanIkincil;
  final Color anaArkaPlanUcuncul;
  final Color popupYuzey;
  final Color popupAltYuzey;
  final Color kartYuzey;
  final Color inceKenar;
  final Color metinBirincilKoyu;
  final Color metinIkincilKoyu;
  final Color metinBirincilAcik;
  final Color metinIkincilAcik;
  final Color suruklemeTutamaci;

  @override
  RestoranTemaRenkleri copyWith({
    Color? anaArkaPlan,
    Color? anaArkaPlanIkincil,
    Color? anaArkaPlanUcuncul,
    Color? popupYuzey,
    Color? popupAltYuzey,
    Color? kartYuzey,
    Color? inceKenar,
    Color? metinBirincilKoyu,
    Color? metinIkincilKoyu,
    Color? metinBirincilAcik,
    Color? metinIkincilAcik,
    Color? suruklemeTutamaci,
  }) {
    return RestoranTemaRenkleri(
      anaArkaPlan: anaArkaPlan ?? this.anaArkaPlan,
      anaArkaPlanIkincil: anaArkaPlanIkincil ?? this.anaArkaPlanIkincil,
      anaArkaPlanUcuncul: anaArkaPlanUcuncul ?? this.anaArkaPlanUcuncul,
      popupYuzey: popupYuzey ?? this.popupYuzey,
      popupAltYuzey: popupAltYuzey ?? this.popupAltYuzey,
      kartYuzey: kartYuzey ?? this.kartYuzey,
      inceKenar: inceKenar ?? this.inceKenar,
      metinBirincilKoyu: metinBirincilKoyu ?? this.metinBirincilKoyu,
      metinIkincilKoyu: metinIkincilKoyu ?? this.metinIkincilKoyu,
      metinBirincilAcik: metinBirincilAcik ?? this.metinBirincilAcik,
      metinIkincilAcik: metinIkincilAcik ?? this.metinIkincilAcik,
      suruklemeTutamaci: suruklemeTutamaci ?? this.suruklemeTutamaci,
    );
  }

  @override
  RestoranTemaRenkleri lerp(
    covariant ThemeExtension<RestoranTemaRenkleri>? other,
    double t,
  ) {
    if (other is! RestoranTemaRenkleri) {
      return this;
    }
    return RestoranTemaRenkleri(
      anaArkaPlan: Color.lerp(anaArkaPlan, other.anaArkaPlan, t)!,
      anaArkaPlanIkincil: Color.lerp(
        anaArkaPlanIkincil,
        other.anaArkaPlanIkincil,
        t,
      )!,
      anaArkaPlanUcuncul: Color.lerp(
        anaArkaPlanUcuncul,
        other.anaArkaPlanUcuncul,
        t,
      )!,
      popupYuzey: Color.lerp(popupYuzey, other.popupYuzey, t)!,
      popupAltYuzey: Color.lerp(popupAltYuzey, other.popupAltYuzey, t)!,
      kartYuzey: Color.lerp(kartYuzey, other.kartYuzey, t)!,
      inceKenar: Color.lerp(inceKenar, other.inceKenar, t)!,
      metinBirincilKoyu: Color.lerp(
        metinBirincilKoyu,
        other.metinBirincilKoyu,
        t,
      )!,
      metinIkincilKoyu: Color.lerp(
        metinIkincilKoyu,
        other.metinIkincilKoyu,
        t,
      )!,
      metinBirincilAcik: Color.lerp(
        metinBirincilAcik,
        other.metinBirincilAcik,
        t,
      )!,
      metinIkincilAcik: Color.lerp(
        metinIkincilAcik,
        other.metinIkincilAcik,
        t,
      )!,
      suruklemeTutamaci: Color.lerp(
        suruklemeTutamaci,
        other.suruklemeTutamaci,
        t,
      )!,
    );
  }
}

extension RestoranTemaUzantisi on BuildContext {
  RestoranTemaRenkleri get restoranTema {
    return Theme.of(this).extension<RestoranTemaRenkleri>() ??
        const RestoranTemaRenkleri(
          anaArkaPlan: AnaSayfaRenkSablonu.arkaPlanKoyu,
          anaArkaPlanIkincil: AnaSayfaRenkSablonu.arkaPlanOrta,
          anaArkaPlanUcuncul: AnaSayfaRenkSablonu.arkaPlanUst,
          popupYuzey: AnaSayfaRenkSablonu.panelKoyu,
          popupAltYuzey: AnaSayfaRenkSablonu.panelYuksek,
          kartYuzey: AnaSayfaRenkSablonu.panelKoyu,
          inceKenar: AnaSayfaRenkSablonu.cerceve,
          metinBirincilKoyu: AnaSayfaRenkSablonu.metinAna,
          metinIkincilKoyu: AnaSayfaRenkSablonu.metinIkincil,
          metinBirincilAcik: AnaSayfaRenkSablonu.metinAna,
          metinIkincilAcik: AnaSayfaRenkSablonu.metinIkincil,
          suruklemeTutamaci: Color(0x80FFFFFF),
        );
  }
}
