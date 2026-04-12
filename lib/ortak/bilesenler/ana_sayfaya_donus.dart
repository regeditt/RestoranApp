import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';

void anaSayfayaDon(BuildContext context) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    RotaYapisi.anaSayfa,
    (Route<dynamic> route) => false,
  );
}
