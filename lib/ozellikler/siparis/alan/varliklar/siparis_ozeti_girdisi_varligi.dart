import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

class SiparisOzetiGirdisiVarligi {
  const SiparisOzetiGirdisiVarligi({required this.sepet, this.qrBaglami});

  final SepetVarligi sepet;
  final QrMenuBaglamiVarligi? qrBaglami;
}
