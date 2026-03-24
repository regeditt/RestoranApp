import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

abstract class MenuDeposu {
  Future<List<KategoriVarligi>> kategorileriGetir();

  Future<List<UrunVarligi>> urunleriGetir();

  Future<List<UrunVarligi>> kategoriyeGoreUrunleriGetir(String kategoriId);

  Future<UrunVarligi?> urunGetir(String urunId);
}
