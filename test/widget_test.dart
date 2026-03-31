import 'package:flutter_test/flutter_test.dart';
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
}
