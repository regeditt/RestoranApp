import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/depolar/asistan_backend_ayar_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/api_destekli_ayar_asistani_yanitlayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/asistan_api_istemcisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/kuralli_ayar_asistani_yanitlayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_backend_ayar_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/asistan_backend_ayarini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/asistan_backend_ayarini_kaydet_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/asistan_backend_baglanti_test_et_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/ayar_asistani_yanit_uret_use_case.dart';

void main() {
  test('Backend URL kaydet ve getir use-case zinciri calisir', () async {
    final _SahteAyarDeposu depo = _SahteAyarDeposu();
    final AsistanBackendAyariniKaydetUseCase kaydetUseCase =
        AsistanBackendAyariniKaydetUseCase(depo);
    final AsistanBackendAyariniGetirUseCase getirUseCase =
        AsistanBackendAyariniGetirUseCase(depo);

    await kaydetUseCase(
      tabanUrl: '  https://api.ornek.com  ',
      apiAnahtari: '  gizli-api-anahtari  ',
    );

    final AsistanBackendAyarVarligi ayar = await getirUseCase();
    expect(ayar.tabanUrl, 'https://api.ornek.com');
    expect(ayar.apiAnahtari, 'gizli-api-anahtari');
  });

  test('Backend baglanti test use-case istemci sonucunu dondurur', () async {
    final _SahteApiIstemcisi istemci = _SahteApiIstemcisi(
      baglantiVar: true,
      yanit: null,
    );
    final AsistanBackendBaglantiTestEtUseCase useCase =
        AsistanBackendBaglantiTestEtUseCase(istemci);

    expect(
      await useCase('https://api.ornek.com', apiAnahtari: 'abc123'),
      isTrue,
    );
    expect(await useCase('   '), isFalse);
    expect(istemci.sonBaglantiTestApiAnahtari, 'abc123');
  });

  test(
    'Api destekli yanitlayici URL tanimliysa API yanitini tercih eder',
    () async {
      final _SahteAyarDeposu depo = _SahteAyarDeposu()
        ..ayar = const AsistanBackendAyarVarligi(
          tabanUrl: 'https://api.ornek.com',
          apiAnahtari: 'api-anahtar-1',
        );
      final _SahteApiIstemcisi istemci = _SahteApiIstemcisi(
        baglantiVar: true,
        yanit: 'API cevabi',
      );
      final AyarAsistaniYanitUretUseCase useCase = AyarAsistaniYanitUretUseCase(
        ApiDestekliAyarAsistaniYanitlayici(
          backendAyarDeposu: depo,
          apiIstemcisi: istemci,
          yedekYanitlayici: const KuralliAyarAsistaniYanitlayici(),
        ),
      );

      expect(await useCase('Merhaba'), 'API cevabi');
      expect(istemci.sonYanitIstekApiAnahtari, 'api-anahtar-1');
    },
  );

  test(
    'Api destekli yanitlayici URL yoksa yerel yedek yaniti kullanir',
    () async {
      final _SahteAyarDeposu depo = _SahteAyarDeposu();
      final _SahteApiIstemcisi istemci = _SahteApiIstemcisi(
        baglantiVar: false,
        yanit: null,
      );
      final AyarAsistaniYanitUretUseCase useCase = AyarAsistaniYanitUretUseCase(
        ApiDestekliAyarAsistaniYanitlayici(
          backendAyarDeposu: depo,
          apiIstemcisi: istemci,
          yedekYanitlayici: const KuralliAyarAsistaniYanitlayici(),
        ),
      );

      final String yanit = await useCase('Lisans');
      expect(yanit, contains('RST-YYYYMMDD-XXXXXX'));
    },
  );

  test(
    'Api destekli yanitlayici URL tanimliyken API bos donerse yerel fallbacke donmez',
    () async {
      final _SahteAyarDeposu depo = _SahteAyarDeposu()
        ..ayar = const AsistanBackendAyarVarligi(
          tabanUrl: 'https://api.ornek.com',
        );
      final _SahteApiIstemcisi istemci = _SahteApiIstemcisi(
        baglantiVar: true,
        yanit: null,
      );
      final AyarAsistaniYanitUretUseCase useCase = AyarAsistaniYanitUretUseCase(
        ApiDestekliAyarAsistaniYanitlayici(
          backendAyarDeposu: depo,
          apiIstemcisi: istemci,
          yedekYanitlayici: const KuralliAyarAsistaniYanitlayici(),
        ),
      );

      final String yanit = await useCase('Lisans');
      expect(yanit, contains('AI servisi'));
      expect(yanit, isNot(contains('RST-YYYYMMDD-XXXXXX')));
    },
  );
}

class _SahteAyarDeposu implements AsistanBackendAyarDeposu {
  AsistanBackendAyarVarligi? ayar;

  @override
  Future<void> kaydet(AsistanBackendAyarVarligi ayar) async {
    this.ayar = ayar;
  }

  @override
  Future<AsistanBackendAyarVarligi?> yukle() async {
    return ayar;
  }
}

class _SahteApiIstemcisi implements AsistanApiIstemcisi {
  _SahteApiIstemcisi({required this.baglantiVar, required this.yanit});

  final bool baglantiVar;
  final String? yanit;
  String sonBaglantiTestApiAnahtari = '';
  String sonYanitIstekApiAnahtari = '';

  @override
  Future<bool> baglantiTestEt(String tabanUrl, {String apiAnahtari = ''}) async {
    sonBaglantiTestApiAnahtari = apiAnahtari;
    return baglantiVar;
  }

  @override
  Future<String?> yanitIste({
    required String tabanUrl,
    required String soru,
    String apiAnahtari = '',
  }) async {
    sonYanitIstekApiAnahtari = apiAnahtari;
    return yanit;
  }
}
