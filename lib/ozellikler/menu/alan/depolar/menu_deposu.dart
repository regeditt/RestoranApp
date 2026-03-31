import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

abstract class MenuDeposu {
  Future<List<KategoriVarligi>> kategorileriGetir();

  Future<void> kategoriEkle(KategoriVarligi kategori);

  Future<void> kategoriGuncelle(KategoriVarligi kategori);

  Future<void> kategoriSil(String kategoriId);

  Future<List<UrunVarligi>> urunleriGetir();

  Future<void> urunEkle(UrunVarligi urun);

  Future<void> urunGuncelle(UrunVarligi urun);

  Future<void> urunSil(String urunId);

  Future<List<UrunVarligi>> kategoriyeGoreUrunleriGetir(String kategoriId);

  Future<UrunVarligi?> urunGetir(String urunId);
}
