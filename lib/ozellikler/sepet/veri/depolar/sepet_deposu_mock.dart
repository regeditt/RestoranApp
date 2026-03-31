import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_secenegi_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

class SepetDeposuMock implements SepetDeposu {
  SepetDeposuMock(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  SepetVarligi _sepet = const SepetVarligi(id: 'sep_001', kalemler: []);

  @override
  Future<SepetVarligi> kalemGuncelle({
    required String kalemId,
    required int adet,
  }) async {
    final List<SepetKalemiVarligi> guncelKalemler = _sepet.kalemler
        .map(
          (kalem) => kalem.id == kalemId
              ? SepetKalemiVarligi(
                  id: kalem.id,
                  urun: kalem.urun,
                  birimFiyat: kalem.birimFiyat,
                  adet: adet,
                  secenekAdi: kalem.secenekAdi,
                  notMetni: kalem.notMetni,
                )
              : kalem,
        )
        .where((kalem) => kalem.adet > 0)
        .toList();

    _sepet = SepetVarligi(id: _sepet.id, kalemler: guncelKalemler);
    return _sepet;
  }

  @override
  Future<SepetVarligi> kalemSil(String kalemId) async {
    _sepet = SepetVarligi(
      id: _sepet.id,
      kalemler: _sepet.kalemler.where((kalem) => kalem.id != kalemId).toList(),
    );
    return _sepet;
  }

  @override
  Future<SepetVarligi> sepetiGetir() async {
    return _sepet;
  }

  @override
  Future<void> sepetiTemizle() async {
    _sepet = SepetVarligi(id: _sepet.id, kalemler: const []);
  }

  @override
  Future<SepetVarligi> urunEkle({
    required String urunId,
    required int adet,
    String? secenekId,
    String? notMetni,
  }) async {
    final UrunVarligi? urun = await _menuDeposu.urunGetir(urunId);

    if (urun == null) {
      throw StateError('Urun bulunamadi');
    }

    final UrunSecenegiVarligi? secilenSecenek = _secenekSec(
      urun: urun,
      secenekId: secenekId,
    );

    final SepetKalemiVarligi yeniKalem = SepetKalemiVarligi(
      id: 'kalem_${_sepet.kalemler.length + 1}',
      urun: urun,
      birimFiyat: urun.fiyat + (secilenSecenek?.fiyatFarki ?? 0),
      adet: adet,
      secenekAdi: secilenSecenek?.ad,
      notMetni: notMetni,
    );

    _sepet = SepetVarligi(
      id: _sepet.id,
      kalemler: [..._sepet.kalemler, yeniKalem],
    );

    return _sepet;
  }

  UrunSecenegiVarligi? _secenekSec({
    required UrunVarligi urun,
    required String? secenekId,
  }) {
    if (urun.secenekler.isEmpty) {
      return null;
    }

    if (secenekId == null) {
      return urun.varsayilanSecenek;
    }

    for (final UrunSecenegiVarligi secenek in urun.secenekler) {
      if (secenek.id == secenekId) {
        return secenek;
      }
    }

    return urun.varsayilanSecenek;
  }
}
