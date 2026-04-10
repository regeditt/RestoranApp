import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

/// Menu, kategori ve urun operasyonlari icin depo kontrati.
abstract class MenuDeposu {
  /// Tum kategorileri sira bilgisiyle getirir.
  Future<List<KategoriVarligi>> kategorileriGetir();

  /// Yeni kategori kaydi ekler.
  Future<void> kategoriEkle(KategoriVarligi kategori);

  /// Mevcut kategori kaydini gunceller.
  Future<void> kategoriGuncelle(KategoriVarligi kategori);

  /// [kategoriId] ile eslesen kategoriyi siler.
  Future<void> kategoriSil(String kategoriId);

  /// Tum urunleri getirir.
  Future<List<UrunVarligi>> urunleriGetir();

  /// Yeni urun kaydi ekler.
  Future<void> urunEkle(UrunVarligi urun);

  /// Mevcut urun kaydini gunceller.
  Future<void> urunGuncelle(UrunVarligi urun);

  /// [urunId] ile eslesen urunu siler.
  Future<void> urunSil(String urunId);

  /// Verilen kategoriye bagli urun listesini getirir.
  Future<List<UrunVarligi>> kategoriyeGoreUrunleriGetir(String kategoriId);

  /// [urunId] ile urun kaydini getirir.
  ///
  /// Kayit bulunamazsa `null` dondurur.
  Future<UrunVarligi?> urunGetir(String urunId);
}
