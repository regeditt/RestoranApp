import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/salon_plani_deposu_mock.dart';

class SalonPlaniDeposuGercek implements SalonPlaniDeposu {
  SalonPlaniDeposuGercek([SalonPlaniDeposu? icDepo])
    : _icDepo = icDepo ?? SalonPlaniDeposuMock();

  final SalonPlaniDeposu _icDepo;

  @override
  Future<void> bolumEkle(SalonBolumuVarligi bolum) {
    return _icDepo.bolumEkle(bolum);
  }

  @override
  Future<void> bolumGuncelle(SalonBolumuVarligi bolum) {
    return _icDepo.bolumGuncelle(bolum);
  }

  @override
  Future<void> bolumSil(String bolumId) {
    return _icDepo.bolumSil(bolumId);
  }

  @override
  Future<List<SalonBolumuVarligi>> bolumleriGetir() {
    return _icDepo.bolumleriGetir();
  }

  @override
  Future<void> masaEkle(String bolumId, MasaTanimiVarligi masa) {
    return _icDepo.masaEkle(bolumId, masa);
  }

  @override
  Future<void> masaGuncelle({
    required String bolumId,
    required MasaTanimiVarligi masa,
  }) {
    return _icDepo.masaGuncelle(bolumId: bolumId, masa: masa);
  }

  @override
  Future<void> masaSil({required String bolumId, required String masaId}) {
    return _icDepo.masaSil(bolumId: bolumId, masaId: masaId);
  }
}
