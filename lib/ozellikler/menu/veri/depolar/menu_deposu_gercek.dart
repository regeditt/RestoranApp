import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_mock.dart';

class MenuDeposuGercek implements MenuDeposu {
  MenuDeposuGercek([MenuDeposu? icDepo]) : _icDepo = icDepo ?? MenuDeposuMock();

  final MenuDeposu _icDepo;

  @override
  Future<void> kategoriEkle(KategoriVarligi kategori) {
    return _icDepo.kategoriEkle(kategori);
  }

  @override
  Future<void> kategoriGuncelle(KategoriVarligi kategori) {
    return _icDepo.kategoriGuncelle(kategori);
  }

  @override
  Future<void> kategoriSil(String kategoriId) {
    return _icDepo.kategoriSil(kategoriId);
  }

  @override
  Future<List<KategoriVarligi>> kategorileriGetir() {
    return _icDepo.kategorileriGetir();
  }

  @override
  Future<List<UrunVarligi>> kategoriyeGoreUrunleriGetir(String kategoriId) {
    return _icDepo.kategoriyeGoreUrunleriGetir(kategoriId);
  }

  @override
  Future<UrunVarligi?> urunGetir(String urunId) {
    return _icDepo.urunGetir(urunId);
  }

  @override
  Future<void> urunEkle(UrunVarligi urun) {
    return _icDepo.urunEkle(urun);
  }

  @override
  Future<void> urunGuncelle(UrunVarligi urun) {
    return _icDepo.urunGuncelle(urun);
  }

  @override
  Future<void> urunSil(String urunId) {
    return _icDepo.urunSil(urunId);
  }

  @override
  Future<List<UrunVarligi>> urunleriGetir() {
    return _icDepo.urunleriGetir();
  }
}
