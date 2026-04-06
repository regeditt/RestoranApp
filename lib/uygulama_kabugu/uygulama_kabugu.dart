import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/tema/uygulama_tema.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';

class UygulamaKabugu extends StatelessWidget {
  const UygulamaKabugu({super.key, this.veriKaynagi = VeriKaynagiTipi.sqlite});

  final VeriKaynagiTipi veriKaynagi;

  @override
  Widget build(BuildContext context) {
    return ServisSaglayici(
      servis: ServisKaydi.olustur(veriKaynagi),
      child: MaterialApp(
        title: 'RestoranApp',
        debugShowCheckedModeBanner: false,
        theme: UygulamaTema.acikTema,
        initialRoute: baslangicRotasiBelirle(
          webMu: kIsWeb,
          platform: defaultTargetPlatform,
        ),
        onGenerateRoute: RotaYapisi.rotaOlustur,
      ),
    );
  }
}

@visibleForTesting
String baslangicRotasiBelirle({
  required bool webMu,
  required TargetPlatform platform,
}) {
  if (webMu) {
    return RotaYapisi.anaSayfa;
  }

  switch (platform) {
    case TargetPlatform.windows:
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
      return RotaYapisi.pos;
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      return RotaYapisi.anaSayfa;
  }
}
