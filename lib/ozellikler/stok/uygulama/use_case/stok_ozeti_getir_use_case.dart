import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';

/// StokOzetiGetirUseCase use-case operasyonunu yurutur.
class StokOzetiGetirUseCase {
  const StokOzetiGetirUseCase(this._stokDeposu, this._menuDeposu);

  final StokDeposu _stokDeposu;
  final MenuDeposu _menuDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<StokOzetiVarligi> call() async {
    final List<HammaddeStokVarligi> hammaddeler = await _stokDeposu
        .hammaddeleriGetir();
    final List<UrunVarligi> urunler = await _menuDeposu.urunleriGetir();

    final Map<String, HammaddeStokVarligi> hammaddeHaritasi =
        <String, HammaddeStokVarligi>{
          for (final HammaddeStokVarligi hammadde in hammaddeler)
            hammadde.id: hammadde,
        };

    final List<MenuMaliyetVarligi> maliyetler = <MenuMaliyetVarligi>[];
    for (final UrunVarligi urun in urunler) {
      final List<ReceteKalemiVarligi> recete = await _stokDeposu.receteyiGetir(
        urun.id,
      );
      double receteMaliyeti = 0;
      int uretilebilirAdet = 0;
      if (recete.isNotEmpty) {
        double? enDusukUretimSiniri;
        for (final ReceteKalemiVarligi kalem in recete) {
          final HammaddeStokVarligi? hammadde =
              hammaddeHaritasi[kalem.hammaddeId];
          if (hammadde != null) {
            receteMaliyeti += hammadde.birimMaliyet * kalem.miktar;
            final double uretimSiniri = kalem.miktar <= 0
                ? 0
                : hammadde.mevcutMiktar / kalem.miktar;
            if (enDusukUretimSiniri == null ||
                uretimSiniri < enDusukUretimSiniri) {
              enDusukUretimSiniri = uretimSiniri;
            }
          }
        }
        uretilebilirAdet = enDusukUretimSiniri?.floor() ?? 0;
      }
      final double karMarjiOrani = urun.fiyat <= 0
          ? 0
          : ((urun.fiyat - receteMaliyeti) / urun.fiyat) * 100;
      maliyetler.add(
        MenuMaliyetVarligi(
          urunAdi: urun.ad,
          satisFiyati: urun.fiyat,
          receteMaliyeti: receteMaliyeti,
          karMarjiOrani: karMarjiOrani,
          uretilebilirAdet: uretilebilirAdet,
        ),
      );
    }

    final List<HammaddeStokVarligi> kritikler =
        hammaddeler
            .where((HammaddeStokVarligi hammadde) => hammadde.kritikMi)
            .toList()
          ..sort((a, b) => a.mevcutMiktar.compareTo(b.mevcutMiktar));

    return StokOzetiVarligi(
      toplamStokDegeri: hammaddeler.fold<double>(
        0,
        (double onceki, HammaddeStokVarligi hammadde) =>
            onceki + hammadde.toplamDeger,
      ),
      kritikMalzemeSayisi: kritikler.length,
      toplamHammaddeSayisi: hammaddeler.length,
      kritikMalzemeler: kritikler
          .take(3)
          .map(
            (HammaddeStokVarligi hammadde) => KritikMalzemeVarligi(
              ad: hammadde.ad,
              kalanMiktarMetni:
                  '${hammadde.mevcutMiktar.toStringAsFixed(0)} ${hammadde.birim}',
              uyariEtiketi: _uyariEtiketiOlustur(hammadde),
              aciliyetOrani: _aciliyetOraniOlustur(hammadde),
            ),
          )
          .toList(),
      menuMaliyetleri: maliyetler
        ..sort((a, b) => a.karMarjiOrani.compareTo(b.karMarjiOrani)),
    );
  }

  String _uyariEtiketiOlustur(HammaddeStokVarligi hammadde) {
    final double oran = _aciliyetOraniOlustur(hammadde);
    if (oran <= 0.5) {
      return 'Acil';
    }
    if (oran <= 0.9) {
      return 'Kritik';
    }
    return 'Izle';
  }

  double _aciliyetOraniOlustur(HammaddeStokVarligi hammadde) {
    if (hammadde.kritikEsik <= 0) {
      return 1;
    }
    return hammadde.mevcutMiktar / hammadde.kritikEsik;
  }
}
