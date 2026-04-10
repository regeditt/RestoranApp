import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';

/// Stok ve recete operasyonlari icin depo kontrati.
abstract class StokDeposu {
  /// Tum hammadde stok kayitlarini getirir.
  Future<List<HammaddeStokVarligi>> hammaddeleriGetir();

  /// [urunId] icin tanimli recete kalemlerini getirir.
  Future<List<ReceteKalemiVarligi>> receteyiGetir(String urunId);

  /// [urunId] icin recete kalemlerini kaydeder.
  Future<void> receteyiKaydet(String urunId, List<ReceteKalemiVarligi> recete);

  /// Yeni hammadde kaydi ekler.
  Future<void> hammaddeEkle(HammaddeStokVarligi hammadde);

  /// Mevcut hammadde kaydini gunceller.
  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde);

  /// Verilen hammadde stokundan [miktar] kadar duser.
  Future<void> stokDus({required String hammaddeId, required double miktar});
}
