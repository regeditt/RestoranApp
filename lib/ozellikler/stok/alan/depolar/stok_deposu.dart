import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';

abstract class StokDeposu {
  Future<List<HammaddeStokVarligi>> hammaddeleriGetir();

  Future<List<ReceteKalemiVarligi>> receteyiGetir(String urunId);

  Future<void> hammaddeEkle(HammaddeStokVarligi hammadde);

  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde);

  Future<void> stokDus({required String hammaddeId, required double miktar});
}
