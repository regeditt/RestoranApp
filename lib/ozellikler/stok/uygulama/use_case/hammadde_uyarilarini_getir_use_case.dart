import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_filtresi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';

class HammaddeleriUyariyaGoreGetirUseCase {
  const HammaddeleriUyariyaGoreGetirUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  Future<List<HammaddeStokVarligi>> call({
    StokUyariFiltresi filtre = StokUyariFiltresi.tum,
  }) async {
    final List<HammaddeStokVarligi> hammaddeler = await _stokDeposu
        .hammaddeleriGetir();
    return hammaddeler.where((HammaddeStokVarligi hammadde) {
      switch (filtre) {
        case StokUyariFiltresi.tum:
          return true;
        case StokUyariFiltresi.uyari:
          return hammadde.uyariDurumu == StokUyariDurumu.uyari;
        case StokUyariFiltresi.kritik:
          return hammadde.uyariDurumu == StokUyariDurumu.kritik;
        case StokUyariFiltresi.tukendi:
          return hammadde.uyariDurumu == StokUyariDurumu.tukendi;
      }
    }).toList();
  }
}
