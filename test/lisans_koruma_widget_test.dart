import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';
import 'package:restoran_app/uygulama_kabugu/uygulama_kabugu.dart';

void main() {
  testWidgets('Ilk acilista deneme surumu ile uygulama acilir', (tester) async {
    await tester.pumpWidget(
      const UygulamaKabugu(veriKaynagi: VeriKaynagiTipi.api),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lisans Korumasi'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
