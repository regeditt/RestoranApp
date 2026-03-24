import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/tema/uygulama_tema.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';

class UygulamaKabugu extends StatelessWidget {
  const UygulamaKabugu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RestoranApp',
      debugShowCheckedModeBanner: false,
      theme: UygulamaTema.acikTema,
      initialRoute: RotaYapisi.anaSayfa,
      onGenerateRoute: RotaYapisi.rotaOlustur,
    );
  }
}
