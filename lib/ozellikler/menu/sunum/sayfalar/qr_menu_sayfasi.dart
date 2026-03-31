import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/sayfalar/musteri_menu_sayfasi.dart';

class QrMenuSayfasi extends StatelessWidget {
  const QrMenuSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MusteriMenuSayfasi(qrModu: true, qrBaglami: _qrBaglaminiOku());
  }

  QrMenuBaglamiVarligi? _qrBaglaminiOku() {
    final Uri taban = Uri.base;
    final Map<String, String> parametreler = <String, String>{
      ...taban.queryParameters,
      ..._fragmentParametreleriniCikar(taban),
    };

    final String? masaNo = parametreler['masa'];
    final String? bolumAdi = parametreler['bolum'];
    final String? kaynak = parametreler['kaynak'];

    if ((masaNo == null || masaNo.isEmpty) &&
        (bolumAdi == null || bolumAdi.isEmpty) &&
        (kaynak == null || kaynak.isEmpty)) {
      return null;
    }

    return QrMenuBaglamiVarligi(
      masaNo: masaNo,
      bolumAdi: bolumAdi,
      kaynak: kaynak,
    );
  }

  Map<String, String> _fragmentParametreleriniCikar(Uri taban) {
    final String fragment = taban.fragment;
    if (!fragment.contains('?')) {
      return const <String, String>{};
    }

    final String sorgu = fragment.split('?').last;
    return Uri.splitQueryString(sorgu);
  }
}
