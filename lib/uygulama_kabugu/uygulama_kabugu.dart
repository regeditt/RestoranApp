import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/tema/uygulama_tema.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';

class UygulamaKabugu extends StatelessWidget {
  const UygulamaKabugu({
    super.key,
    this.veriKaynagi = VeriKaynagiTipi.sqlite,
  });

  final VeriKaynagiTipi veriKaynagi;

  @override
  Widget build(BuildContext context) {
    return ServisSaglayici(
      servis: ServisKaydi.olustur(veriKaynagi),
      child: MaterialApp(
        title: 'RestoranApp',
        debugShowCheckedModeBanner: false,
        theme: UygulamaTema.acikTema,
        initialRoute: RotaYapisi.anaSayfa,
        onGenerateRoute: RotaYapisi.rotaOlustur,
      ),
    );
  }
}
