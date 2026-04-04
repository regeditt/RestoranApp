import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_mock.dart';

class SeedVerisiSaglayici {
  const SeedVerisiSaglayici();

  Future<List<KategoriVarligi>> kategorileriGetir() {
    final MenuDeposuMock mock = MenuDeposuMock();
    return mock.kategorileriGetir();
  }

  Future<List<UrunVarligi>> urunleriGetir() {
    final MenuDeposuMock mock = MenuDeposuMock();
    return mock.urunleriGetir();
  }
}
