import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';
import 'package:restoran_app/ozellikler/lisans/alan/varliklar/lisans_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart';

/// LisansAktifEtSonucu use-case operasyonunu yurutur.
class LisansAktifEtSonucu {
  const LisansAktifEtSonucu._({
    required this.basariliMi,
    required this.mesaj,
    this.durum,
  });

  const LisansAktifEtSonucu.basarili(LisansDurumuVarligi durum)
    : this._(basariliMi: true, mesaj: 'Lisans aktif edildi.', durum: durum);

  const LisansAktifEtSonucu.hata(String mesaj)
    : this._(basariliMi: false, mesaj: mesaj);

  final bool basariliMi;
  final String mesaj;
  final LisansDurumuVarligi? durum;
}

/// LisansAktifEtUseCase use-case operasyonunu yurutur.
class LisansAktifEtUseCase {
  const LisansAktifEtUseCase(this._lisansDeposu, this._dogrulayici);

  final LisansDeposu _lisansDeposu;
  final LisansAnahtariDogrulayici _dogrulayici;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<LisansAktifEtSonucu> call(
    String girilenAnahtar, {
    DateTime? simdi,
  }) async {
    final LisansAnahtariDogrulamaSonucu sonuc = _dogrulayici.dogrula(
      girilenAnahtar,
      simdi: simdi,
    );
    if (!sonuc.gecerliMi) {
      return LisansAktifEtSonucu.hata(sonuc.mesaj);
    }

    await _lisansDeposu.lisansAnahtariKaydet(sonuc.duzenlenmisAnahtar!);
    return LisansAktifEtSonucu.basarili(
      LisansDurumuVarligi.aktif(
        mesaj: 'Lisans aktif.',
        anahtar: sonuc.duzenlenmisAnahtar!,
        gecerlilikTarihi: sonuc.gecerlilikTarihi!,
      ),
    );
  }
}
