import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ortak/platform/cihaz_kimligi_saglayici.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/use_case/lisans_durumu_getir_use_case.dart';
import 'package:restoran_app/ozellikler/lisans/veri/depolar/lisans_deposu_mock.dart';

void main() {
  const _SahteCihazKimligiSaglayici cihazKimligiSaglayici =
      _SahteCihazKimligiSaglayici('A1B2C3');
  const LisansAnahtariDogrulayici dogrulayici = LisansAnahtariDogrulayici();

  test('Lisans yoksa ilk 15 gun deneme surumu aktif olur', () async {
    final LisansDeposuMock depo = LisansDeposuMock();
    final LisansDurumuGetirUseCase useCase = LisansDurumuGetirUseCase(
      depo,
      dogrulayici,
      cihazKimligiSaglayici,
    );

    final sonuc = await useCase(simdi: DateTime(2026, 4, 11));

    expect(sonuc.aktifMi, isTrue);
    expect(sonuc.denemeMi, isTrue);
    expect(sonuc.kalanDenemeGunu, 15);
  });

  test('15 gun sonunda lisans zorunlu olur', () async {
    final LisansDeposuMock depo = LisansDeposuMock(
      baslangicDenemeTarihi: DateTime(2026, 4, 1),
    );
    final LisansDurumuGetirUseCase useCase = LisansDurumuGetirUseCase(
      depo,
      dogrulayici,
      cihazKimligiSaglayici,
    );

    final sonuc = await useCase(simdi: DateTime(2026, 4, 16));

    expect(sonuc.aktifMi, isFalse);
    expect(sonuc.mesaj, contains('Deneme suresi doldu'));
  });
}

class _SahteCihazKimligiSaglayici implements CihazKimligiSaglayici {
  const _SahteCihazKimligiSaglayici(this._cihazKodu);

  final String _cihazKodu;

  @override
  String cihazKoduGetir() => _cihazKodu;
}
