import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/anasayfa/sunum/sayfalar/ana_sayfa.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/sayfalar/giris_secim_sayfasi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/sayfalar/hesabim_sayfasi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/sayfalar/musteri_menu_sayfasi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/sayfalar/qr_menu_sayfasi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_ozeti_girdisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/sayfalar/siparis_ozeti_sayfasi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/sayfalar/yonetim_paneli_sayfasi.dart';

class RotaYapisi {
  const RotaYapisi._();

  static const String anaSayfa = '/';
  static const String vitrin = '/ana-sayfa';
  static const String hesabim = '/hesabim';
  static const String musteriMenusu = '/musteri-menusu';
  static const String qrMenu = '/qr-menu';
  static const String pos = '/pos';
  static const String siparisOzeti = '/siparis-ozeti';
  static const String yonetimPaneli = '/yonetim-paneli';

  static Route<dynamic> rotaOlustur(RouteSettings ayarlar) {
    switch (ayarlar.name) {
      case anaSayfa:
        return MaterialPageRoute<void>(
          builder: (_) => const GirisSecimSayfasi(),
          settings: ayarlar,
        );
      case vitrin:
        return MaterialPageRoute<void>(
          builder: (_) => const AnaSayfa(),
          settings: ayarlar,
        );
      case musteriMenusu:
        return MaterialPageRoute<void>(
          builder: (_) => const QrMenuSayfasi(),
          settings: ayarlar,
        );
      case qrMenu:
        return MaterialPageRoute<void>(
          builder: (_) => const QrMenuSayfasi(),
          settings: ayarlar,
        );
      case pos:
        return MaterialPageRoute<void>(
          builder: (_) => const MusteriMenuSayfasi(),
          settings: ayarlar,
        );
      case hesabim:
        return MaterialPageRoute<void>(
          builder: (_) => const HesabimSayfasi(),
          settings: ayarlar,
        );
      case siparisOzeti:
        final Object? arguman = ayarlar.arguments;
        final SiparisOzetiGirdisiVarligi? girdi = switch (arguman) {
          SiparisOzetiGirdisiVarligi() => arguman,
          SepetVarligi() => SiparisOzetiGirdisiVarligi(sepet: arguman),
          _ => null,
        };
        if (girdi == null) {
          return MaterialPageRoute<void>(
            builder: (_) => const QrMenuSayfasi(),
            settings: ayarlar,
          );
        }
        return MaterialPageRoute<bool>(
          builder: (_) => SiparisOzetiSayfasi(
            sepet: girdi.sepet,
            qrBaglami: girdi.qrBaglami,
          ),
          settings: ayarlar,
        );
      case yonetimPaneli:
        return MaterialPageRoute<void>(
          builder: (_) => const YonetimPaneliSayfasi(),
          settings: ayarlar,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const GirisSecimSayfasi(),
          settings: ayarlar,
        );
    }
  }
}
