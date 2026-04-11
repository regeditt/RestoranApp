import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/sayfalar/hesabim_sayfasi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/hesabim_viewmodel.dart';
import 'package:restoran_app/ozellikler/rezervasyon/sunum/sayfalar/rezervasyon_sayfasi.dart';
import 'package:restoran_app/ozellikler/rezervasyon/sunum/viewmodel/rezervasyon_viewmodel.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/sayfalar/mutfak_siparis_sayfasi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/sayfalar/siparis_ozeti_sayfasi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/siparis_ozeti_viewmodel.dart';
import 'test_destegi.dart';

void main() {
  testWidgets('Mutfak sayfasi dar ekranda tasma hatasi vermez', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(320, 640));
    final MutfakSiparisViewModel viewModel =
        MutfakSiparisViewModel.servisKaydindan(ServisKaydi.mock());
    await tester.pumpWidget(
      testUygulamasi(child: MutfakSiparisSayfasi(viewModel: viewModel)),
    );
    await _kisaBekleme(tester);

    _beklenmeyenHataYok(tester);
  });

  testWidgets('Rezervasyon ekle dialogu dar ekranda tasma hatasi vermez', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(320, 640));
    final RezervasyonViewModel viewModel = RezervasyonViewModel.servisKaydindan(
      ServisKaydi.mock(),
    );
    await tester.pumpWidget(
      testUygulamasi(child: RezervasyonSayfasi(viewModel: viewModel)),
    );
    await _kisaBekleme(tester);

    await tester.tap(find.text('Rezervasyon ekle'));
    await _kisaBekleme(tester);

    expect(find.text('Rezervasyon ekle'), findsWidgets);
    _beklenmeyenHataYok(tester);
  });

  testWidgets('Siparis ozeti dar ekranda tasma hatasi vermez', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    final ServisKaydi servisKaydi = ServisKaydi.mock();
    await servisKaydi.sepeteUrunEkleUseCase(urunId: 'urn_001', adet: 1);
    final SepetVarligi sepet = await servisKaydi.sepetiGetirUseCase();
    final SiparisOzetiViewModel viewModel =
        SiparisOzetiViewModel.servisKaydindan(servisKaydi, sepet: sepet);

    await tester.binding.setSurfaceSize(const Size(320, 640));
    await tester.pumpWidget(
      testUygulamasi(child: SiparisOzetiSayfasi(viewModel: viewModel)),
    );
    await _kisaBekleme(tester);

    _beklenmeyenHataYok(tester);
  });

  testWidgets('Hesabim masaustu ekranda tasma hatasi vermez', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    final ServisKaydi servisKaydi = ServisKaydi.mock();
    await servisKaydi.girisYapUseCase(
      telefon: 'admin',
      sifre: '123456',
      rol: KullaniciRolu.yonetici,
    );
    final HesabimViewModel viewModel = HesabimViewModel.servisKaydindan(
      servisKaydi,
    );

    await tester.binding.setSurfaceSize(const Size(1366, 768));
    await tester.pumpWidget(
      testUygulamasi(child: HesabimSayfasi(viewModel: viewModel)),
    );
    await _kisaBekleme(tester);

    expect(find.text('Cikis yap'), findsOneWidget);
    _beklenmeyenHataYok(tester);
  });

  testWidgets('Hesabim dar ekranda tasma hatasi vermez', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    final ServisKaydi servisKaydi = ServisKaydi.mock();
    await servisKaydi.girisYapUseCase(
      telefon: 'admin',
      sifre: '123456',
      rol: KullaniciRolu.yonetici,
    );
    final HesabimViewModel viewModel = HesabimViewModel.servisKaydindan(
      servisKaydi,
    );

    await tester.binding.setSurfaceSize(const Size(320, 640));
    await tester.pumpWidget(
      testUygulamasi(child: HesabimSayfasi(viewModel: viewModel)),
    );
    await _kisaBekleme(tester);

    _beklenmeyenHataYok(tester);
  });
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
