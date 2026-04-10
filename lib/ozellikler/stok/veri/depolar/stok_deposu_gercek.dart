import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/stok/veri/depolar/stok_deposu_mock.dart';

class StokDeposuGercek implements StokDeposu {
  StokDeposuGercek([StokDeposu? icDepo]) : _icDepo = icDepo ?? StokDeposuMock();

  final StokDeposu _icDepo;

  @override
  Future<List<HammaddeStokVarligi>> hammaddeleriGetir() {
    return _icDepo.hammaddeleriGetir();
  }

  @override
  Future<void> hammaddeEkle(HammaddeStokVarligi hammadde) {
    return _icDepo.hammaddeEkle(hammadde);
  }

  @override
  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde) {
    return _icDepo.hammaddeGuncelle(hammadde);
  }

  @override
  Future<List<ReceteKalemiVarligi>> receteyiGetir(String urunId) {
    return _icDepo.receteyiGetir(urunId);
  }

  @override
  Future<void> receteyiKaydet(String urunId, List<ReceteKalemiVarligi> recete) {
    return _icDepo.receteyiKaydet(urunId, recete);
  }

  @override
  Future<void> stokDus({required String hammaddeId, required double miktar}) {
    return _icDepo.stokDus(hammaddeId: hammaddeId, miktar: miktar);
  }
}
