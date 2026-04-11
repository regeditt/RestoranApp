import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/veri/depolar/sepet_deposu_mock.dart';

class SepetDeposuGercek implements SepetDeposu {
  SepetDeposuGercek(MenuDeposu menuDeposu, [SepetDeposu? icDepo])
    : _icDepo = icDepo ?? SepetDeposuMock(menuDeposu);

  final SepetDeposu _icDepo;

  @override
  Future<SepetVarligi> kalemGuncelle({
    required String kalemId,
    required int adet,
  }) {
    return _icDepo.kalemGuncelle(kalemId: kalemId, adet: adet);
  }

  @override
  Future<SepetVarligi> kalemSil(String kalemId) {
    return _icDepo.kalemSil(kalemId);
  }

  @override
  Future<SepetVarligi> sepetiGetir() {
    return _icDepo.sepetiGetir();
  }

  @override
  Future<void> sepetiTemizle() {
    return _icDepo.sepetiTemizle();
  }

  @override
  Future<SepetVarligi> kuponKoduGuncelle(String? kuponKodu) {
    return _icDepo.kuponKoduGuncelle(kuponKodu);
  }

  @override
  Future<SepetVarligi> urunEkle({
    required String urunId,
    required int adet,
    String? secenekId,
    String? notMetni,
  }) {
    return _icDepo.urunEkle(
      urunId: urunId,
      adet: adet,
      secenekId: secenekId,
      notMetni: notMetni,
    );
  }
}
