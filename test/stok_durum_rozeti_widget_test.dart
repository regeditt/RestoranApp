import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_rapor_kartlari.dart';

void main() {
  testWidgets('StokVeMaliyetKarti durum rozetlerini gosterir', (
    WidgetTester tester,
  ) async {
    final StokOzetiVarligi ozet = StokOzetiVarligi(
      toplamStokDegeri: 1500,
      alarmliMalzemeSayisi: 3,
      uyariMalzemeSayisi: 1,
      kritikMalzemeSayisi: 1,
      tukenenMalzemeSayisi: 1,
      toplamHammaddeSayisi: 12,
      kritikMalzemeler: const <KritikMalzemeVarligi>[],
      stokUyariKalemleri: const <StokUyariKalemiVarligi>[
        StokUyariKalemiVarligi(
          ad: 'Un',
          kalanMiktarMetni: '0 kg',
          uyariEtiketi: 'Stokta yok',
          aciliyetOrani: 0,
          durum: StokUyariDurumu.tukendi,
        ),
      ],
      haftalikKritikAlarmOzetleri: const <HaftalikKritikAlarmOzetiVarligi>[
        HaftalikKritikAlarmOzetiVarligi(
          hammaddeId: 'ham_1',
          hammaddeAdi: 'Un',
          alarmAdedi: 4,
        ),
      ],
      menuMaliyetleri: const <MenuMaliyetVarligi>[],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: StokVeMaliyetKarti(ozet: ozet)),
      ),
    );

    expect(find.text('Uyari 1'), findsOneWidget);
    expect(find.text('Kritik 1'), findsOneWidget);
    expect(find.text('Tukendi 1'), findsOneWidget);
    expect(find.text('Haftalik kritik alarm ilk 10'), findsOneWidget);
  });
}
