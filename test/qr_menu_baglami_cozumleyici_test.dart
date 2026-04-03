import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_baglami_cozumleyici.dart';

void main() {
  test('query parametrelerinden qr baglamini cozer', () {
    final uri = Uri.parse(
      'https://restoranapp.local/qr-menu?masa=12&bolum=teras&kaynak=qr',
    );

    final baglam = QrMenuBaglamiCozumleyici.uriTabanindanOku(uri);

    expect(baglam, isNotNull);
    expect(baglam!.masaNo, '12');
    expect(baglam.bolumAdi, 'teras');
    expect(baglam.kaynak, 'qr');
  });

  test('kaynak verilmezse varsayilan qr kullanir', () {
    final uri = Uri.parse('https://restoranapp.local/qr-menu?masa=5');

    final baglam = QrMenuBaglamiCozumleyici.uriTabanindanOku(uri);

    expect(baglam, isNotNull);
    expect(baglam!.masaNo, '5');
    expect(baglam.kaynak, 'qr');
  });

  test('gercek qr url uretir', () {
    final url = QrMenuBaglamiCozumleyici.qrUrlOlustur(
      tabanUrl: 'https://restoranapp.local',
      masaNo: '8',
      bolumAdi: 'salon',
    );

    expect(
      url,
      'https://restoranapp.local/qr-menu?masa=8&bolum=salon&kaynak=qr',
    );
  });
}
