import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';

/// QR menuden gelen URI parametrelerini okuyup menu baglamina cevirir.
class QrMenuBaglamiCozumleyici {
  const QrMenuBaglamiCozumleyici._();

  static QrMenuBaglamiVarligi? uriTabanindanOku(Uri uri) {
    final Map<String, String> parametreler = <String, String>{
      ...uri.queryParameters,
      ..._fragmentParametreleriniCikar(uri),
    };

    final String? masaNo = _temizle(parametreler['masa']);
    final String? bolumAdi = _temizle(parametreler['bolum']);
    final String? kaynak = _temizle(parametreler['kaynak']);

    if (masaNo == null && bolumAdi == null && kaynak == null) {
      return null;
    }

    return QrMenuBaglamiVarligi(
      masaNo: masaNo,
      bolumAdi: bolumAdi,
      kaynak: kaynak ?? 'qr',
    );
  }

  static String qrUrlOlustur({
    required String tabanUrl,
    String? masaNo,
    String? bolumAdi,
    String? kaynak,
  }) {
    final Uri tabanUri = Uri.parse(tabanUrl);
    final Map<String, String> parametreler = <String, String>{};
    final String? temizMasaNo = _temizle(masaNo);
    final String? temizBolumAdi = _temizle(bolumAdi);
    final String? temizKaynak = _temizle(kaynak);

    if (temizMasaNo != null) {
      parametreler['masa'] = temizMasaNo;
    }
    if (temizBolumAdi != null) {
      parametreler['bolum'] = temizBolumAdi;
    }
    parametreler['kaynak'] = temizKaynak ?? 'qr';

    return tabanUri
        .replace(
          path: '/qr-menu',
          queryParameters: parametreler,
          fragment: null,
        )
        .toString();
  }

  static Map<String, String> _fragmentParametreleriniCikar(Uri taban) {
    final String fragment = taban.fragment;
    if (!fragment.contains('?')) {
      return const <String, String>{};
    }

    final String sorgu = fragment.split('?').last;
    return Uri.splitQueryString(sorgu);
  }

  static String? _temizle(String? deger) {
    if (deger == null) {
      return null;
    }

    final String temiz = deger.trim();
    if (temiz.isEmpty) {
      return null;
    }

    return temiz;
  }
}
