import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/yazici_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class YaziciDeposuSqlite implements YaziciDeposu {
  YaziciDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;
  final YaziciDeposuMock _seedDeposu = YaziciDeposuMock();
  bool _seedKontrolEdildi = false;

  @override
  Future<List<YaziciDurumuVarligi>> yazicilariGetir() async {
    await _seedEminOl();
    final kayitlar = await _veritabani
        .select(_veritabani.yaziciKayitlari)
        .get();
    return kayitlar
        .map(
          (kayit) => YaziciDurumuVarligi(
            id: kayit.id,
            ad: kayit.ad,
            rolEtiketi: kayit.rolEtiketi,
            baglantiNoktasi: kayit.baglantiNoktasi,
            aciklama: kayit.aciklama,
            durum: YaziciBaglantiDurumu.values[kayit.durum],
          ),
        )
        .toList();
  }

  @override
  Future<YaziciDurumuVarligi> yaziciEkle(YaziciDurumuVarligi yazici) async {
    await _seedEminOl();
    await _yaziciKaydet(yazici);
    return yazici;
  }

  @override
  Future<YaziciDurumuVarligi> yaziciGuncelle(YaziciDurumuVarligi yazici) async {
    await _seedEminOl();
    await _yaziciKaydet(yazici);
    return yazici;
  }

  @override
  Future<void> yaziciSil(String yaziciId) async {
    await _seedEminOl();
    await (_veritabani.delete(
      _veritabani.yaziciKayitlari,
    )..where((tbl) => tbl.id.equals(yaziciId))).go();
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final mevcutKayitlar = await _veritabani
        .select(_veritabani.yaziciKayitlari)
        .get();
    if (mevcutKayitlar.isNotEmpty) {
      _seedKontrolEdildi = true;
      return;
    }
    final yazicilar = await _seedDeposu.yazicilariGetir();
    await _veritabani.transaction(() async {
      for (final yazici in yazicilar) {
        await _yaziciKaydet(yazici);
      }
    });
    _seedKontrolEdildi = true;
  }

  Future<void> _yaziciKaydet(YaziciDurumuVarligi yazici) async {
    final String id = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'yazici_kayitlari',
      adayKimlik: yazici.id,
    );
    await _veritabani
        .into(_veritabani.yaziciKayitlari)
        .insertOnConflictUpdate(
          YaziciKayitlariCompanion(
            id: Value(id),
            ad: Value(yazici.ad),
            rolEtiketi: Value(yazici.rolEtiketi),
            baglantiNoktasi: Value(yazici.baglantiNoktasi),
            aciklama: Value(yazici.aciklama),
            durum: Value(yazici.durum.index),
          ),
        );
  }
}
