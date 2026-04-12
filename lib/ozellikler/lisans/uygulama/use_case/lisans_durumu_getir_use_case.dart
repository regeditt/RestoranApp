import 'package:restoran_app/ortak/platform/cihaz_kimligi_saglayici.dart';
import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';
import 'package:restoran_app/ozellikler/lisans/alan/varliklar/lisans_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart';

/// LisansDurumuGetirUseCase use-case operasyonunu yurutur.
class LisansDurumuGetirUseCase {
  const LisansDurumuGetirUseCase(
    this._lisansDeposu,
    this._dogrulayici,
    this._cihazKimligiSaglayici, {
    this.denemeGunSayisi = 15,
  });

  final LisansDeposu _lisansDeposu;
  final LisansAnahtariDogrulayici _dogrulayici;
  final CihazKimligiSaglayici _cihazKimligiSaglayici;
  final int denemeGunSayisi;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<LisansDurumuVarligi> call({DateTime? simdi}) async {
    final DateTime kontrolZamani = simdi ?? DateTime.now();
    final String cihazKodu = _cihazKimligiSaglayici.cihazKoduGetir();

    final String? kayitliLisans = await _lisansDeposu
        .kayitliLisansAnahtariGetir();
    String? lisansHataMesaji;
    if (kayitliLisans != null && kayitliLisans.trim().isNotEmpty) {
      final LisansAnahtariDogrulamaSonucu sonuc = _dogrulayici.dogrula(
        kayitliLisans,
        cihazKodu: cihazKodu,
        simdi: kontrolZamani,
      );
      if (sonuc.gecerliMi) {
        return LisansDurumuVarligi.aktifLisansli(
          mesaj: 'Lisans aktif.',
          anahtar: sonuc.duzenlenmisAnahtar!,
          gecerlilikTarihi: sonuc.gecerlilikTarihi!,
          cihazKodu: cihazKodu,
        );
      }
      lisansHataMesaji = sonuc.mesaj;
    }

    final DateTime denemeBaslangic = await _denemeBaslangicTarihiniHazirla(
      kontrolZamani,
    );
    final DateTime denemeBitis = denemeBaslangic.add(
      Duration(days: denemeGunSayisi - 1),
    );
    final DateTime denemeBitisAnlik = DateTime(
      denemeBitis.year,
      denemeBitis.month,
      denemeBitis.day,
      23,
      59,
      59,
    );

    if (!kontrolZamani.isAfter(denemeBitisAnlik)) {
      final int kalanGun =
          denemeBitis
              .difference(
                DateTime(
                  kontrolZamani.year,
                  kontrolZamani.month,
                  kontrolZamani.day,
                ),
              )
              .inDays +
          1;
      final String mesaj = lisansHataMesaji == null
          ? 'Deneme surumu aktif. Kalan $kalanGun gun.'
          : 'Kayitli lisans gecersiz: $lisansHataMesaji. Deneme surumu aktif. Kalan $kalanGun gun.';

      return LisansDurumuVarligi.aktifDeneme(
        mesaj: mesaj,
        cihazKodu: cihazKodu,
        denemeBitisTarihi: denemeBitis,
        kalanDenemeGunu: kalanGun,
      );
    }

    final String mesaj = lisansHataMesaji == null
        ? 'Deneme suresi doldu. Devam etmek icin lisans anahtari girin.'
        : 'Kayitli lisans gecersiz: $lisansHataMesaji. Deneme suresi doldu. Devam etmek icin lisans anahtari girin.';

    return LisansDurumuVarligi.pasif(
      mesaj,
      cihazKodu: cihazKodu,
      denemeBitisTarihi: denemeBitis,
      kalanDenemeGunu: 0,
    );
  }

  Future<DateTime> _denemeBaslangicTarihiniHazirla(
    DateTime kontrolZamani,
  ) async {
    final DateTime? kayitliBaslangic = await _lisansDeposu
        .denemeBaslangicTarihiGetir();
    if (kayitliBaslangic != null) {
      return DateTime(
        kayitliBaslangic.year,
        kayitliBaslangic.month,
        kayitliBaslangic.day,
      );
    }

    final DateTime yeniBaslangic = DateTime(
      kontrolZamani.year,
      kontrolZamani.month,
      kontrolZamani.day,
    );
    await _lisansDeposu.denemeBaslangicTarihiKaydet(yeniBaslangic);
    return yeniBaslangic;
  }
}
