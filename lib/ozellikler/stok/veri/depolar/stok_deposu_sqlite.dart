import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_alarm_gecmisi_kaydi_varligi.dart';
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
            uyariEsigi: kayit.uyariEsigi,
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
    final HammaddeStokVarligi yeniKayit = hammadde.copyWith(id: id);
    await _hammaddeKaydet(yeniKayit);
    await _stokAlarmGecmisiKaydet(
      oncekiKayit: null,
      yeniKayit: yeniKayit,
      tetikleyenIslem: 'hammadde_ekleme',
    );
  }

  @override
  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde) async {
    await _seedEminOl();
    final String id = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'hammadde_kayitlari',
      adayKimlik: hammadde.id,
    );
    final HammaddeStokVarligi? oncekiKayit = await _hammaddeGetir(id);
    final HammaddeStokVarligi yeniKayit = hammadde.copyWith(id: id);
    await _hammaddeKaydet(yeniKayit);
    await _stokAlarmGecmisiKaydet(
      oncekiKayit: oncekiKayit,
      yeniKayit: yeniKayit,
      tetikleyenIslem: 'manuel_guncelleme',
    );
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
    final HammaddeStokVarligi oncekiKayit = HammaddeStokVarligi(
      id: mevcut.id,
      ad: mevcut.ad,
      birim: mevcut.birim,
      mevcutMiktar: mevcut.mevcutMiktar,
      uyariEsigi: mevcut.uyariEsigi,
      kritikEsik: mevcut.kritikEsik,
      birimMaliyet: mevcut.birimMaliyet,
    );
    final HammaddeStokVarligi yeniKayit = oncekiKayit.copyWith(
      mevcutMiktar: yeniMiktar,
    );
    await (_veritabani.update(_veritabani.hammaddeKayitlari)
          ..where((tbl) => tbl.id.equals(hammaddeId)))
        .write(HammaddeKayitlariCompanion(mevcutMiktar: Value(yeniMiktar)));
    await _stokAlarmGecmisiKaydet(
      oncekiKayit: oncekiKayit,
      yeniKayit: yeniKayit,
      tetikleyenIslem: 'siparis_stok_dusumu',
    );
  }

  @override
  Future<List<StokAlarmGecmisiKaydiVarligi>> stokAlarmGecmisiGetir({
    DateTime? baslangicTarihi,
    DateTime? bitisTarihi,
    int limit = 500,
  }) async {
    await _seedEminOl();
    final sorgu = _veritabani.select(_veritabani.stokAlarmGecmisKayitlari)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.zaman, mode: OrderingMode.desc),
      ])
      ..limit(limit);
    if (baslangicTarihi != null) {
      sorgu.where((tbl) => tbl.zaman.isBiggerOrEqualValue(baslangicTarihi));
    }
    if (bitisTarihi != null) {
      sorgu.where((tbl) => tbl.zaman.isSmallerOrEqualValue(bitisTarihi));
    }
    final List<StokAlarmGecmisKayitlariData> kayitlar = await sorgu.get();
    return kayitlar.map(_alarmKaydiniVarligaDonustur).toList();
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
            uyariEsigi: Value(hammadde.uyariEsigi),
            kritikEsik: Value(hammadde.kritikEsik),
            birimMaliyet: Value(hammadde.birimMaliyet),
          ),
        );
  }

  Future<HammaddeStokVarligi?> _hammaddeGetir(String id) async {
    final HammaddeKayitlariData? kayit = await (_veritabani.select(
      _veritabani.hammaddeKayitlari,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (kayit == null) {
      return null;
    }
    return HammaddeStokVarligi(
      id: kayit.id,
      ad: kayit.ad,
      birim: kayit.birim,
      mevcutMiktar: kayit.mevcutMiktar,
      uyariEsigi: kayit.uyariEsigi,
      kritikEsik: kayit.kritikEsik,
      birimMaliyet: kayit.birimMaliyet,
    );
  }

  Future<void> _stokAlarmGecmisiKaydet({
    required HammaddeStokVarligi? oncekiKayit,
    required HammaddeStokVarligi yeniKayit,
    required String tetikleyenIslem,
  }) async {
    final StokUyariDurumu oncekiDurum =
        oncekiKayit?.uyariDurumu ?? StokUyariDurumu.normal;
    final StokUyariDurumu yeniDurum = yeniKayit.uyariDurumu;
    if (yeniDurum == StokUyariDurumu.normal || oncekiDurum == yeniDurum) {
      return;
    }
    final DateTime simdi = DateTime.now();
    await _veritabani
        .into(_veritabani.stokAlarmGecmisKayitlari)
        .insert(
          StokAlarmGecmisKayitlariCompanion.insert(
            id: 'alm_${simdi.microsecondsSinceEpoch}',
            zaman: simdi,
            hammaddeId: yeniKayit.id,
            hammaddeAdi: yeniKayit.ad,
            oncekiMiktar: oncekiKayit?.mevcutMiktar ?? yeniKayit.mevcutMiktar,
            yeniMiktar: yeniKayit.mevcutMiktar,
            oncekiDurum: oncekiDurum.index,
            yeniDurum: yeniDurum.index,
            tetikleyenIslem: tetikleyenIslem,
          ),
        );
  }

  StokAlarmGecmisiKaydiVarligi _alarmKaydiniVarligaDonustur(
    StokAlarmGecmisKayitlariData kayit,
  ) {
    final StokUyariDurumu oncekiDurum =
        kayit.oncekiDurum >= 0 &&
            kayit.oncekiDurum < StokUyariDurumu.values.length
        ? StokUyariDurumu.values[kayit.oncekiDurum]
        : StokUyariDurumu.normal;
    final StokUyariDurumu yeniDurum =
        kayit.yeniDurum >= 0 && kayit.yeniDurum < StokUyariDurumu.values.length
        ? StokUyariDurumu.values[kayit.yeniDurum]
        : StokUyariDurumu.normal;
    return StokAlarmGecmisiKaydiVarligi(
      id: kayit.id,
      zaman: kayit.zaman,
      hammaddeId: kayit.hammaddeId,
      hammaddeAdi: kayit.hammaddeAdi,
      oncekiMiktar: kayit.oncekiMiktar,
      yeniMiktar: kayit.yeniMiktar,
      oncekiDurum: oncekiDurum,
      yeniDurum: yeniDurum,
      tetikleyenIslem: kayit.tetikleyenIslem,
    );
  }
}
