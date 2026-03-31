import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/sayfalar/mutfak_siparis_sayfasi.dart';
import 'package:restoran_app/uygulama_kabugu/uygulama_kabugu.dart';

void main() {
  testWidgets('RestoranApp ilk ekrani gosterir', (WidgetTester tester) async {
    await tester.pumpWidget(const UygulamaKabugu());
    await tester.pumpAndSettle();

    expect(find.text('RestoranApp'), findsOneWidget);
    expect(find.text('Musteri girisi'), findsWidgets);
    expect(find.text('Garson girisi'), findsWidgets);
    expect(find.text('Yonetici girisi'), findsWidgets);
    expect(find.text('Musteri olarak devam et'), findsOneWidget);
  });

  testWidgets('RestoranApp ilk ekrani dar genislikte de gosterir', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(430, 932));
    await tester.pumpWidget(const UygulamaKabugu());
    await tester.pumpAndSettle();

    expect(find.text('RestoranApp'), findsOneWidget);
    expect(find.text('Musteri olarak devam et'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mutfak ekrani filtre ve kolonlari gosterir', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const MaterialApp(home: MutfakSiparisSayfasi()));
    await tester.pumpAndSettle();

    expect(find.text('Mutfak Siparis Yonetimi'), findsOneWidget);
    expect(find.text('Yonetim paneli'), findsOneWidget);
    expect(find.text('Rol secimine don'), findsOneWidget);
    expect(find.text('Yazici senkronu'), findsOneWidget);
    expect(find.text('Tum kanallar'), findsOneWidget);
    expect(find.text('Aktif is'), findsOneWidget);
    expect(find.text('Yeni'), findsOneWidget);
    expect(find.text('Salon'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
