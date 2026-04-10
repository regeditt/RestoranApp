import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';

/// Urunleri recete-hammadde stok uygunluguna gore stokta/stokta degil olarak hazirlar.
class StokDurumluUrunHazirlayici {
  const StokDurumluUrunHazirlayici._();

  static Future<List<UrunVarligi>> hazirla({
    required List<UrunVarligi> urunler,
    required StokDeposu stokDeposu,
  }) async {
    final List<HammaddeStokVarligi> hammaddeler = await stokDeposu
        .hammaddeleriGetir();
    final Map<String, HammaddeStokVarligi> hammaddeHaritasi =
        <String, HammaddeStokVarligi>{
          for (final HammaddeStokVarligi hammadde in hammaddeler)
            hammadde.id: hammadde,
        };

    final List<UrunVarligi> sonuc = <UrunVarligi>[];
    for (final UrunVarligi urun in urunler) {
      final List<ReceteKalemiVarligi> recete = await stokDeposu.receteyiGetir(
        urun.id,
      );
      if (recete.isEmpty) {
        sonuc.add(urun);
        continue;
      }

      bool uretilebilirMi = true;
      for (final ReceteKalemiVarligi kalem in recete) {
        final HammaddeStokVarligi? hammadde =
            hammaddeHaritasi[kalem.hammaddeId];
        if (hammadde == null || hammadde.mevcutMiktar < kalem.miktar) {
          uretilebilirMi = false;
          break;
        }
      }

      sonuc.add(urun.copyWith(stoktaMi: urun.stoktaMi && uretilebilirMi));
    }
    return sonuc;
  }
}
