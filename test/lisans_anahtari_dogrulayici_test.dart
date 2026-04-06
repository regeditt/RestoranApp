import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/lisans/veri/depolar/lisans_deposu_mock.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/use_case/lisans_aktif_et_use_case.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/use_case/lisans_durumu_getir_use_case.dart';

void main() {
  test('Uretilen lisans anahtari dogrulamadan gecer', () {
    final LisansAnahtariDogrulayici dogrulayici =
        const LisansAnahtariDogrulayici();
    final DateTime gecerlilikTarihi = DateTime(2028, 12, 31);
    final String anahtar = dogrulayici.lisansAnahtariOlustur(gecerlilikTarihi);

    final LisansAnahtariDogrulamaSonucu sonuc = dogrulayici.dogrula(
      anahtar,
      simdi: DateTime(2028, 1, 1),
    );

    expect(sonuc.gecerliMi, isTrue);
    expect(sonuc.gecerlilikTarihi, gecerlilikTarihi);
  });

  test('Suresi dolmus lisans anahtari reddedilir', () {
    final LisansAnahtariDogrulayici dogrulayici =
        const LisansAnahtariDogrulayici();
    final String anahtar = dogrulayici.lisansAnahtariOlustur(
      DateTime(2025, 1, 1),
    );

    final LisansAnahtariDogrulamaSonucu sonuc = dogrulayici.dogrula(
      anahtar,
      simdi: DateTime(2026, 1, 1),
    );

    expect(sonuc.gecerliMi, isFalse);
    expect(sonuc.mesaj, contains('suresi dolmus'));
  });

  test('Lisans aktif etme use-case dogru anahtari kaydeder', () async {
    final LisansAnahtariDogrulayici dogrulayici =
        const LisansAnahtariDogrulayici();
    final LisansDeposuMock depo = LisansDeposuMock();
    final LisansAktifEtUseCase lisansAktifEtUseCase = LisansAktifEtUseCase(
      depo,
      dogrulayici,
    );
    final LisansDurumuGetirUseCase lisansDurumuGetirUseCase =
        LisansDurumuGetirUseCase(depo, dogrulayici);
    final String anahtar = dogrulayici.lisansAnahtariOlustur(
      DateTime(2027, 10, 15),
    );

    final LisansAktifEtSonucu aktifEtSonucu = await lisansAktifEtUseCase(
      anahtar,
      simdi: DateTime(2027, 1, 1),
    );
    final durum = await lisansDurumuGetirUseCase(simdi: DateTime(2027, 1, 1));

    expect(aktifEtSonucu.basariliMi, isTrue);
    expect(durum.aktifMi, isTrue);
    expect(durum.anahtar, anahtar);
  });
}
