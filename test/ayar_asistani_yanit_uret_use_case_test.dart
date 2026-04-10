import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/kuralli_ayar_asistani_yanitlayici.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/ayar_asistani_yanit_uret_use_case.dart';

void main() {
  test(
    'AyarAsistaniYanitUretUseCase lisans sorusuna lisans yaniti verir',
    () async {
      const AyarAsistaniYanitUretUseCase useCase = AyarAsistaniYanitUretUseCase(
        KuralliAyarAsistaniYanitlayici(),
      );

      final String yanit = await useCase('Lisans anahtari nasil girilir?');

      expect(yanit, contains('RST-YYYYMMDD-XXXXXX'));
    },
  );

  test('AyarAsistaniYanitUretUseCase hizli soru etiketlerini sunar', () {
    const AyarAsistaniYanitUretUseCase useCase = AyarAsistaniYanitUretUseCase(
      KuralliAyarAsistaniYanitlayici(),
    );

    expect(useCase.hizliSoruEtiketleri, contains('Kullanici bulunamadi'));
    expect(useCase.acilisMesaji, isNotEmpty);
  });
}
