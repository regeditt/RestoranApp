import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/salon_plani_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class SalonPlaniDeposuSqlite implements SalonPlaniDeposu {
  SalonPlaniDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;
  final SalonPlaniDeposuMock _seedDeposu = SalonPlaniDeposuMock();
  bool _seedKontrolEdildi = false;

  @override
  Future<List<SalonBolumuVarligi>> bolumleriGetir() async {
    await _seedEminOl();
    return _bolumleriOku();
  }

  @override
  Future<void> bolumEkle(SalonBolumuVarligi bolum) async {
    await _seedEminOl();
    final String bolumId = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'salon_bolum_kayitlari',
      adayKimlik: bolum.id,
    );
    await _veritabani
        .into(_veritabani.salonBolumKayitlari)
        .insertOnConflictUpdate(
          SalonBolumKayitlariCompanion(
            id: Value(bolumId),
            ad: Value(bolum.ad),
            aciklama: Value(bolum.aciklama),
          ),
        );
    for (final masa in bolum.masalar) {
      final String masaId = await _veritabani.numerikKimlikCozumle(
        tabloAdi: 'masa_kayitlari',
        adayKimlik: masa.id,
      );
      await _veritabani
          .into(_veritabani.masaKayitlari)
          .insertOnConflictUpdate(
            MasaKayitlariCompanion(
              id: Value(masaId),
              bolumId: Value(bolumId),
              ad: Value(masa.ad),
              kapasite: Value(masa.kapasite),
            ),
          );
    }
  }

  @override
  Future<void> bolumGuncelle(SalonBolumuVarligi bolum) async {
    await _seedEminOl();
    await (_veritabani.update(
      _veritabani.salonBolumKayitlari,
    )..where((tbl) => tbl.id.equals(bolum.id))).write(
      SalonBolumKayitlariCompanion(
        ad: Value(bolum.ad),
        aciklama: Value(bolum.aciklama),
      ),
    );
  }

  @override
  Future<void> bolumSil(String bolumId) async {
    await _seedEminOl();
    await _veritabani.transaction(() async {
      await (_veritabani.delete(
        _veritabani.masaKayitlari,
      )..where((tbl) => tbl.bolumId.equals(bolumId))).go();
      await (_veritabani.delete(
        _veritabani.salonBolumKayitlari,
      )..where((tbl) => tbl.id.equals(bolumId))).go();
    });
  }

  @override
  Future<void> masaEkle(String bolumId, MasaTanimiVarligi masa) async {
    await _seedEminOl();
    final String masaId = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'masa_kayitlari',
      adayKimlik: masa.id,
    );
    await _veritabani
        .into(_veritabani.masaKayitlari)
        .insertOnConflictUpdate(
          MasaKayitlariCompanion(
            id: Value(masaId),
            bolumId: Value(bolumId),
            ad: Value(masa.ad),
            kapasite: Value(masa.kapasite),
          ),
        );
  }

  @override
  Future<void> masaGuncelle({
    required String bolumId,
    required MasaTanimiVarligi masa,
  }) async {
    await _seedEminOl();
    await (_veritabani.update(
      _veritabani.masaKayitlari,
    )..where((tbl) => tbl.id.equals(masa.id))).write(
      MasaKayitlariCompanion(
        bolumId: Value(bolumId),
        ad: Value(masa.ad),
        kapasite: Value(masa.kapasite),
      ),
    );
  }

  @override
  Future<void> masaSil({
    required String bolumId,
    required String masaId,
  }) async {
    await _seedEminOl();
    await (_veritabani.delete(_veritabani.masaKayitlari)
          ..where((tbl) => tbl.id.equals(masaId) & tbl.bolumId.equals(bolumId)))
        .go();
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final mevcutBolumler = await _veritabani
        .select(_veritabani.salonBolumKayitlari)
        .get();
    if (mevcutBolumler.isNotEmpty) {
      _seedKontrolEdildi = true;
      return;
    }

    final List<SalonBolumuVarligi> bolumler = await _seedDeposu
        .bolumleriGetir();
    await _veritabani.transaction(() async {
      for (final bolum in bolumler) {
        final String bolumId = await _veritabani.sonrakiNumerikKimlikGetir(
          tabloAdi: 'salon_bolum_kayitlari',
        );
        await _veritabani
            .into(_veritabani.salonBolumKayitlari)
            .insertOnConflictUpdate(
              SalonBolumKayitlariCompanion(
                id: Value(bolumId),
                ad: Value(bolum.ad),
                aciklama: Value(bolum.aciklama),
              ),
            );
        for (final masa in bolum.masalar) {
          final String masaId = await _veritabani.sonrakiNumerikKimlikGetir(
            tabloAdi: 'masa_kayitlari',
          );
          await _veritabani
              .into(_veritabani.masaKayitlari)
              .insertOnConflictUpdate(
                MasaKayitlariCompanion(
                  id: Value(masaId),
                  bolumId: Value(bolumId),
                  ad: Value(masa.ad),
                  kapasite: Value(masa.kapasite),
                ),
              );
        }
      }
    });
    _seedKontrolEdildi = true;
  }

  Future<List<SalonBolumuVarligi>> _bolumleriOku() async {
    final bolumKayitlari = await _veritabani
        .select(_veritabani.salonBolumKayitlari)
        .get();
    if (bolumKayitlari.isEmpty) {
      return <SalonBolumuVarligi>[];
    }
    final bolumIdleri = bolumKayitlari.map((item) => item.id).toList();
    final masaKayitlari = await (_veritabani.select(
      _veritabani.masaKayitlari,
    )..where((tbl) => tbl.bolumId.isIn(bolumIdleri))).get();
    final Map<String, List<MasaKayitlariData>> masaHaritasi =
        <String, List<MasaKayitlariData>>{};
    for (final masa in masaKayitlari) {
      (masaHaritasi[masa.bolumId] ??= <MasaKayitlariData>[]).add(masa);
    }

    return bolumKayitlari
        .map(
          (bolum) => SalonBolumuVarligi(
            id: bolum.id,
            ad: bolum.ad,
            aciklama: bolum.aciklama,
            masalar: (masaHaritasi[bolum.id] ?? <MasaKayitlariData>[])
                .map(
                  (masa) => MasaTanimiVarligi(
                    id: masa.id,
                    ad: masa.ad,
                    kapasite: masa.kapasite,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }
}
