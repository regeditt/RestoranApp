import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';
import 'package:restoran_app/ozellikler/lisans/alan/varliklar/lisans_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart';

/// LisansDurumuGetirUseCase use-case operasyonunu yurutur.
class LisansDurumuGetirUseCase {
  const LisansDurumuGetirUseCase(this._lisansDeposu, this._dogrulayici);

  final LisansDeposu _lisansDeposu;
  final LisansAnahtariDogrulayici _dogrulayici;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<LisansDurumuVarligi> call({DateTime? simdi}) async {
    final String? kayitliLisans = await _lisansDeposu
        .kayitliLisansAnahtariGetir();
    if (kayitliLisans == null || kayitliLisans.trim().isEmpty) {
      return const LisansDurumuVarligi.pasif(
        'Uygulama kilitli. Devam etmek icin lisans anahtari girin.',
      );
    }

    final LisansAnahtariDogrulamaSonucu sonuc = _dogrulayici.dogrula(
      kayitliLisans,
      simdi: simdi,
    );
    if (!sonuc.gecerliMi) {
      return LisansDurumuVarligi.pasif(
        'Kayitli lisans gecersiz: ${sonuc.mesaj}',
      );
    }

    return LisansDurumuVarligi.aktif(
      mesaj: 'Lisans aktif.',
      anahtar: sonuc.duzenlenmisAnahtar!,
      gecerlilikTarihi: sonuc.gecerlilikTarihi!,
    );
  }
}
