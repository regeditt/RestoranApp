import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';
import 'package:restoran_app/uygulama_kabugu/uygulama_kabugu.dart';

void main() {
  testWidgets('Lisans yoksa aktivasyon ekrani acilir', (tester) async {
    await tester.pumpWidget(
      const UygulamaKabugu(veriKaynagi: VeriKaynagiTipi.api),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lisans Korumasi'), findsOneWidget);
    expect(find.text('Lisansi aktif et'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
