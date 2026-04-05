import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/stok/veri/depolar/stok_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/seed_verisi_saglayici.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class StokDeposuSqlite implements StokDeposu {
  StokDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;
  final StokDeposuMock _seedDeposu = StokDeposuMock();
  final SeedVerisiSaglayici _seedSaglayici = const SeedVerisiSaglayici();
  bool _seedKontrolEdildi = false;

  @override
  Future<List<HammaddeStokVarligi>> hammaddeleriGetir() async {
    await _seedEminOl();
    final kayitlar = await _veritabani
        .select(_veritabani.hammaddeKayitlari)
        .get();
    return kayitlar
        .map(
          (kayit) => HammaddeStokVarligi(
            id: kayit.id,
            ad: kayit.ad,
            birim: kayit.birim,
            mevcutMiktar: kayit.mevcutMiktar,
            kritikEsik: kayit.kritikEsik,
            birimMaliyet: kayit.birimMaliyet,
          ),
        )
        .toList();
  }

  @override
  Future<List<ReceteKalemiVarligi>> receteyiGetir(String urunId) async {
    await _seedEminOl();
    final kayitlar = await (_veritabani.select(
      _veritabani.receteKalemKayitlari,
    )..where((tbl) => tbl.urunId.equals(urunId))).get();
    return kayitlar
        .map(
          (kayit) => ReceteKalemiVarligi(
            hammaddeId: kayit.hammaddeId,
            miktar: kayit.miktar,
          ),
        )
        .toList();
  }

  @override
  Future<void> receteyiKaydet(
    String urunId,
    List<ReceteKalemiVarligi> recete,
  ) async {
    await _seedEminOl();
    final String? urunKimligi =
        await (_veritabani.select(_veritabani.urunKayitlari)
              ..where((tbl) => tbl.id.equals(urunId)))
            .map((row) => row.id)
            .getSingleOrNull();
    if (urunKimligi == null) {
      return;
    }
    await _veritabani.transaction(() async {
      await (_veritabani.delete(
        _veritabani.receteKalemKayitlari,
      )..where((tbl) => tbl.urunId.equals(urunKimligi))).go();
      for (final kalem in recete) {
        final String? hammaddeKimligi =
            await (_veritabani.select(_veritabani.hammaddeKayitlari)
                  ..where((tbl) => tbl.id.equals(kalem.hammaddeId)))
                .map((row) => row.id)
                .getSingleOrNull();
        if (hammaddeKimligi == null) {
          continue;
        }
        await _veritabani
            .into(_veritabani.receteKalemKayitlari)
            .insertOnConflictUpdate(
              ReceteKalemKayitlariCompanion(
                urunId: Value(urunKimligi),
                hammaddeId: Value(hammaddeKimligi),
                miktar: Value(kalem.miktar),
              ),
            );
      }
    });
  }

  @override
  Future<void> hammaddeEkle(HammaddeStokVarligi hammadde) async {
    await _seedEminOl();
    final String id = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'hammadde_kayitlari',
      adayKimlik: hammadde.id,
    );
    await _hammaddeKaydet(hammadde.copyWith(id: id));
  }

  @override
  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde) async {
    await _seedEminOl();
    final String id = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'hammadde_kayitlari',
      adayKimlik: hammadde.id,
    );
    await _hammaddeKaydet(hammadde.copyWith(id: id));
  }

  @override
  Future<void> stokDus({
    required String hammaddeId,
    required double miktar,
  }) async {
    await _seedEminOl();
    final mevcut = await (_veritabani.select(
      _veritabani.hammaddeKayitlari,
    )..where((tbl) => tbl.id.equals(hammaddeId))).getSingleOrNull();
    if (mevcut == null) {
      return;
    }
    final double yeniMiktar = (mevcut.mevcutMiktar - miktar).clamp(
      0,
      double.infinity,
    );
    await (_veritabani.update(_veritabani.hammaddeKayitlari)
          ..where((tbl) => tbl.id.equals(hammaddeId)))
        .write(HammaddeKayitlariCompanion(mevcutMiktar: Value(yeniMiktar)));
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final mevcutHammadde = await _veritabani
        .select(_veritabani.hammaddeKayitlari)
        .get();
    if (mevcutHammadde.isNotEmpty) {
      _seedKontrolEdildi = true;
      return;
    }

    final List<HammaddeStokVarligi> hammaddeler = await _seedDeposu
        .hammaddeleriGetir();
    final List<UrunVarligi> tohumUrunler = await _seedSaglayici.urunleriGetir();
    final List<UrunKayitlariData> kayitliUrunler = await _veritabani
        .select(_veritabani.urunKayitlari)
        .get();
    final Map<String, String> urunIdHaritasi = <String, String>{
      for (final UrunVarligi tohumUrun in tohumUrunler)
        if (kayitliUrunler.any((kayit) => kayit.ad == tohumUrun.ad))
          tohumUrun.id: kayitliUrunler
              .firstWhere((kayit) => kayit.ad == tohumUrun.ad)
              .id,
    };
    final receteler = <String, List<ReceteKalemiVarligi>>{};
    final Map<String, String> hammaddeIdHaritasi = <String, String>{};

    await _veritabani.transaction(() async {
      for (final hammadde in hammaddeler) {
        final String id = await _veritabani.sonrakiNumerikKimlikGetir(
          tabloAdi: 'hammadde_kayitlari',
        );
        hammaddeIdHaritasi[hammadde.id] = id;
        await _hammaddeKaydet(hammadde.copyWith(id: id));
      }
      for (final UrunVarligi tohumUrun in tohumUrunler) {
        final String? urunId = urunIdHaritasi[tohumUrun.id];
        if (urunId == null) {
          continue;
        }
        final List<ReceteKalemiVarligi> recete = await _seedDeposu
            .receteyiGetir(tohumUrun.id);
        if (recete.isEmpty) {
          continue;
        }
        receteler[urunId] = recete;
      }

      for (final giris in receteler.entries) {
        for (final kalem in giris.value) {
          final String? hammaddeId = hammaddeIdHaritasi[kalem.hammaddeId];
          if (hammaddeId == null) {
            continue;
          }
          await _veritabani
              .into(_veritabani.receteKalemKayitlari)
              .insertOnConflictUpdate(
                ReceteKalemKayitlariCompanion(
                  urunId: Value(giris.key),
                  hammaddeId: Value(hammaddeId),
                  miktar: Value(kalem.miktar),
                ),
              );
        }
      }
    });
    _seedKontrolEdildi = true;
  }

  Future<void> _hammaddeKaydet(HammaddeStokVarligi hammadde) {
    return _veritabani
        .into(_veritabani.hammaddeKayitlari)
        .insertOnConflictUpdate(
          HammaddeKayitlariCompanion(
            id: Value(hammadde.id),
            ad: Value(hammadde.ad),
            birim: Value(hammadde.birim),
            mevcutMiktar: Value(hammadde.mevcutMiktar),
            kritikEsik: Value(hammadde.kritikEsik),
            birimMaliyet: Value(hammadde.birimMaliyet),
          ),
        );
  }
}
