import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/sayfalar/musteri_menu_sayfasi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/viewmodel/musteri_menu_viewmodel.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_baglami_cozumleyici.dart';

class QrMenuSayfasi extends StatelessWidget {
  const QrMenuSayfasi({super.key, this.qrBaglami});

  final QrMenuBaglamiVarligi? qrBaglami;

  @override
  Widget build(BuildContext context) {
    final servisKaydi = ServisSaglayici.of(context);
    return MusteriMenuSayfasi(
      viewModel: MusteriMenuViewModel.servisKaydindan(servisKaydi),
      qrModu: true,
      qrBaglami:
          qrBaglami ?? QrMenuBaglamiCozumleyici.uriTabanindanOku(Uri.base),
    );
  }
}
