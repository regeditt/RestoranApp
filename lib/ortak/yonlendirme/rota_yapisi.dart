import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/anasayfa/sunum/sayfalar/ana_sayfa.dart';

class RotaYapisi {
  const RotaYapisi._();

  static const String anaSayfa = '/';

  static Route<dynamic> rotaOlustur(RouteSettings ayarlar) {
    switch (ayarlar.name) {
      case anaSayfa:
        return MaterialPageRoute<void>(
          builder: (_) => const AnaSayfa(),
          settings: ayarlar,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const AnaSayfa(),
          settings: ayarlar,
        );
    }
  }
}
