import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/rol_yetki_politikasi_varsayilan.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/islem_yetkisi_kontrol_et_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_mock.dart';

void main() {
  test(
    'Aktif kullanici yoksa yetki kontrolu geriye donuk olarak true doner',
    () async {
      final KimlikDeposuMock depo = KimlikDeposuMock();
      const RolYetkiPolitikasiVarsayilan politika =
          RolYetkiPolitikasiVarsayilan();
      final IslemYetkisiKontrolEtUseCase useCase = IslemYetkisiKontrolEtUseCase(
        depo,
        politika,
      );

      final bool sonuc = await useCase(IslemYetkisi.siparisIptalEt);

      expect(sonuc, isTrue);
    },
  );

  test('Garson siparis iptal edemez, durum ilerletebilir', () async {
    final KimlikDeposuMock depo = KimlikDeposuMock();
    const RolYetkiPolitikasiVarsayilan politika =
        RolYetkiPolitikasiVarsayilan();
    final IslemYetkisiKontrolEtUseCase useCase = IslemYetkisiKontrolEtUseCase(
      depo,
      politika,
    );
    await depo.girisYap(
      telefon: 'garson_1',
      sifre: '1234',
      rol: KullaniciRolu.garson,
      adSoyad: 'Garson Bir',
    );

    final bool iptalYetkisi = await useCase(IslemYetkisi.siparisIptalEt);
    final bool ilerletmeYetkisi = await useCase(
      IslemYetkisi.siparisDurumuIlerle,
    );

    expect(iptalYetkisi, isFalse);
    expect(ilerletmeYetkisi, isTrue);
  });
}
