import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';

void main() {
  const List<Size> ekranlar = <Size>[
    Size(320, 640),
    Size(768, 1024),
    Size(1366, 768),
  ];

  const List<String> korunanRotalar = <String>[
    RotaYapisi.anaSayfa,
    RotaYapisi.qrMenu,
    RotaYapisi.hesabim,
    RotaYapisi.pos,
    RotaYapisi.onlineSiparisKanali,
    RotaYapisi.rezervasyon,
    RotaYapisi.odemeKasa,
    RotaYapisi.mutfak,
    RotaYapisi.raporlar,
    RotaYapisi.yonetimPaneli,
  ];

  for (final Size ekran in ekranlar) {
    for (final String rota in korunanRotalar) {
      testWidgets(
        'Sistem alanlari overflow vermez - ${ekran.width.toInt()}x${ekran.height.toInt()} - $rota',
        (WidgetTester tester) async {
          addTearDown(() async {
            await tester.binding.setSurfaceSize(null);
          });

          await tester.binding.setSurfaceSize(ekran);
          final ServisKaydi servisKaydi = ServisKaydi.mock();
          await servisKaydi.girisYapUseCase(
            telefon: 'admin',
            sifre: '123456',
            rol: KullaniciRolu.yonetici,
          );

          await tester.pumpWidget(
            ServisSaglayici(
              servis: servisKaydi,
              child: MaterialApp(
                initialRoute: rota,
                onGenerateRoute: RotaYapisi.rotaOlustur,
              ),
            ),
          );
          await _kisaBekleme(tester);
          _beklenmeyenHataYok(tester);
        },
      );
    }
  }

  for (final Size ekran in ekranlar) {
    testWidgets(
      'Personel giris overflow vermez - ${ekran.width.toInt()}x${ekran.height.toInt()}',
      (WidgetTester tester) async {
        addTearDown(() async {
          await tester.binding.setSurfaceSize(null);
        });

        await tester.binding.setSurfaceSize(ekran);
        final ServisKaydi servisKaydi = ServisKaydi.mock();

        await tester.pumpWidget(
          ServisSaglayici(
            servis: servisKaydi,
            child: MaterialApp(
              initialRoute: RotaYapisi.personelGiris,
              onGenerateRoute: RotaYapisi.rotaOlustur,
            ),
          ),
        );
        await _kisaBekleme(tester);
        _beklenmeyenHataYok(tester);
      },
    );
  }
}

Future<void> _kisaBekleme(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
  await tester.pump(const Duration(milliseconds: 250));
}

void _beklenmeyenHataYok(WidgetTester tester) {
  final Object? hata = tester.takeException();
  if (hata == null) {
    expect(hata, isNull);
    return;
  }
  if (hata is FlutterError) {
    fail(hata.toStringDeep());
  }
  fail(hata.toString());
}
