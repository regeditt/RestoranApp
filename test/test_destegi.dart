import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';

Widget testUygulamasi({required Widget child}) {
  return ServisSaglayici(
    servis: ServisKaydi.mock(),
    child: MaterialApp(home: child),
  );
}
