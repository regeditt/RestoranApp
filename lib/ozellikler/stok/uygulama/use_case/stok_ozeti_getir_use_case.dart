import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_alarm_gecmisi_kaydi_varligi.dart';
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

    final List<HammaddeStokVarligi> alarmliHammaddeler =
        hammaddeler
            .where(
              (HammaddeStokVarligi hammadde) =>
                  hammadde.uyariDurumu != StokUyariDurumu.normal,
            )
            .toList()
          ..sort(_hammaddeAlarmOnceligiKarsilastir);

    final int kritikMalzemeSayisi = alarmliHammaddeler.where((hammadde) {
      return hammadde.uyariDurumu == StokUyariDurumu.kritik;
    }).length;
    final int uyariMalzemeSayisi = alarmliHammaddeler.where((hammadde) {
      return hammadde.uyariDurumu == StokUyariDurumu.uyari;
    }).length;
    final int tukenenMalzemeSayisi = alarmliHammaddeler.where((hammadde) {
      return hammadde.uyariDurumu == StokUyariDurumu.tukendi;
    }).length;
    final List<HaftalikKritikAlarmOzetiVarligi> haftalikKritikAlarmOzetleri =
        await _haftalikKritikAlarmOzetleriniOlustur(hammaddeHaritasi);

    return StokOzetiVarligi(
      toplamStokDegeri: hammaddeler.fold<double>(
        0,
        (double onceki, HammaddeStokVarligi hammadde) =>
            onceki + hammadde.toplamDeger,
      ),
      alarmliMalzemeSayisi: alarmliHammaddeler.length,
      uyariMalzemeSayisi: uyariMalzemeSayisi,
      kritikMalzemeSayisi: kritikMalzemeSayisi,
      tukenenMalzemeSayisi: tukenenMalzemeSayisi,
      toplamHammaddeSayisi: hammaddeler.length,
      kritikMalzemeler: alarmliHammaddeler
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
      stokUyariKalemleri: alarmliHammaddeler
          .take(8)
          .map(
            (HammaddeStokVarligi hammadde) => StokUyariKalemiVarligi(
              ad: hammadde.ad,
              kalanMiktarMetni:
                  '${hammadde.mevcutMiktar.toStringAsFixed(0)} ${hammadde.birim}',
              uyariEtiketi: _uyariEtiketiOlustur(hammadde),
              aciliyetOrani: _aciliyetOraniOlustur(hammadde),
              durum: hammadde.uyariDurumu,
            ),
          )
          .toList(),
      haftalikKritikAlarmOzetleri: haftalikKritikAlarmOzetleri,
      menuMaliyetleri: maliyetler
        ..sort((a, b) => a.karMarjiOrani.compareTo(b.karMarjiOrani)),
    );
  }

  Future<List<HaftalikKritikAlarmOzetiVarligi>>
  _haftalikKritikAlarmOzetleriniOlustur(
    Map<String, HammaddeStokVarligi> hammaddeHaritasi,
  ) async {
    final DateTime simdi = DateTime.now();
    final DateTime baslangic = simdi.subtract(const Duration(days: 7));
    final List<StokAlarmGecmisiKaydiVarligi> alarmKayitlari = await _stokDeposu
        .stokAlarmGecmisiGetir(
          baslangicTarihi: baslangic,
          bitisTarihi: simdi,
          limit: 5000,
        );
    final Map<String, int> alarmSayaci = <String, int>{};
    for (final StokAlarmGecmisiKaydiVarligi kayit in alarmKayitlari) {
      final bool kritikSeviyeyeGiris =
          kayit.yeniDurum == StokUyariDurumu.kritik ||
          kayit.yeniDurum == StokUyariDurumu.tukendi;
      if (!kritikSeviyeyeGiris) {
        continue;
      }
      alarmSayaci[kayit.hammaddeId] = (alarmSayaci[kayit.hammaddeId] ?? 0) + 1;
    }
    final List<HaftalikKritikAlarmOzetiVarligi> sonuc = alarmSayaci.entries.map(
      (MapEntry<String, int> giris) {
        final String ad =
            hammaddeHaritasi[giris.key]?.ad ??
            alarmKayitlari
                .firstWhere((kayit) => kayit.hammaddeId == giris.key)
                .hammaddeAdi;
        return HaftalikKritikAlarmOzetiVarligi(
          hammaddeId: giris.key,
          hammaddeAdi: ad,
          alarmAdedi: giris.value,
        );
      },
    ).toList()..sort((a, b) => b.alarmAdedi.compareTo(a.alarmAdedi));
    if (sonuc.length <= 10) {
      return sonuc;
    }
    return sonuc.take(10).toList();
  }

  String _uyariEtiketiOlustur(HammaddeStokVarligi hammadde) {
    switch (hammadde.uyariDurumu) {
      case StokUyariDurumu.tukendi:
        return 'Stokta yok';
      case StokUyariDurumu.kritik:
        return 'Kritik seviye';
      case StokUyariDurumu.uyari:
        return 'Yenileme uyarisi';
      case StokUyariDurumu.normal:
        return 'Normal';
    }
  }

  int _hammaddeAlarmOnceligiKarsilastir(
    HammaddeStokVarligi a,
    HammaddeStokVarligi b,
  ) {
    final int durumSirasi = _durumOncelikSkoru(
      a.uyariDurumu,
    ).compareTo(_durumOncelikSkoru(b.uyariDurumu));
    if (durumSirasi != 0) {
      return durumSirasi;
    }
    return _aciliyetOraniOlustur(a).compareTo(_aciliyetOraniOlustur(b));
  }

  int _durumOncelikSkoru(StokUyariDurumu durum) {
    switch (durum) {
      case StokUyariDurumu.tukendi:
        return 0;
      case StokUyariDurumu.kritik:
        return 1;
      case StokUyariDurumu.uyari:
        return 2;
      case StokUyariDurumu.normal:
        return 3;
    }
  }

  double _aciliyetOraniOlustur(HammaddeStokVarligi hammadde) {
    if (hammadde.uyariDurumu == StokUyariDurumu.tukendi) {
      return 0;
    }
    if (hammadde.kritikEsik <= 0) {
      return 1;
    }
    if (hammadde.mevcutMiktar <= hammadde.kritikEsik) {
      return hammadde.mevcutMiktar / hammadde.kritikEsik;
    }
    final double uyariAraligi = hammadde.uyariEsigi - hammadde.kritikEsik;
    if (uyariAraligi <= 0) {
      return 1;
    }
    final double normalize =
        (hammadde.mevcutMiktar - hammadde.kritikEsik) / uyariAraligi;
    if (normalize < 0) {
      return 0;
    }
    if (normalize > 1) {
      return 2;
    }
    return 1 + normalize;
  }
}
