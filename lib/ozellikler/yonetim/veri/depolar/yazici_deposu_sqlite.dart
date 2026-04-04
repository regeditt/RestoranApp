import 'dart:convert';

import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/yazici_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class YaziciDeposuSqlite implements YaziciDeposu {
  YaziciDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;
  final YaziciDeposuMock _seedDeposu = YaziciDeposuMock();
  bool _seedKontrolEdildi = false;

  static const String _yaziciVeriAnahtari = 'yonetim_yazicilar_v1';
  static const String _yaziciSeedAnahtari = 'yonetim_yazicilar_seeded';

  @override
  Future<List<YaziciDurumuVarligi>> yazicilariGetir() async {
    await _seedEminOl();
    return _yazicilariOku();
  }

  @override
  Future<YaziciDurumuVarligi> yaziciEkle(YaziciDurumuVarligi yazici) async {
    await _seedEminOl();
    final List<YaziciDurumuVarligi> yazicilar = await _yazicilariOku();
    yazicilar.add(yazici);
    await _yazicilariYaz(yazicilar);
    return yazici;
  }

  @override
  Future<YaziciDurumuVarligi> yaziciGuncelle(YaziciDurumuVarligi yazici) async {
    await _seedEminOl();
    final List<YaziciDurumuVarligi> yazicilar = await _yazicilariOku();
    final int index = yazicilar.indexWhere(
      (YaziciDurumuVarligi kayit) => kayit.id == yazici.id,
    );
    if (index >= 0) {
      yazicilar[index] = yazici;
      await _yazicilariYaz(yazicilar);
    }
    return yazici;
  }

  @override
  Future<void> yaziciSil(String yaziciId) async {
    await _seedEminOl();
    final List<YaziciDurumuVarligi> yazicilar = await _yazicilariOku();
    yazicilar.removeWhere((YaziciDurumuVarligi yazici) => yazici.id == yaziciId);
    await _yazicilariYaz(yazicilar);
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final String? seedDurumu = await _veritabani.ayarOku(_yaziciSeedAnahtari);
    if (seedDurumu == 'true') {
      _seedKontrolEdildi = true;
      return;
    }

    final List<YaziciDurumuVarligi> yazicilar = await _seedDeposu.yazicilariGetir();
    await _yazicilariYaz(yazicilar);
    await _veritabani.ayarYaz(_yaziciSeedAnahtari, 'true');
    _seedKontrolEdildi = true;
  }

  Future<List<YaziciDurumuVarligi>> _yazicilariOku() async {
    final String? jsonVeri = await _veritabani.ayarOku(_yaziciVeriAnahtari);
    if (jsonVeri == null || jsonVeri.isEmpty) {
      return <YaziciDurumuVarligi>[];
    }

    final dynamic ham = jsonDecode(jsonVeri);
    if (ham is! List) {
      return <YaziciDurumuVarligi>[];
    }

    return ham
        .map((kayit) => Map<String, Object?>.from(kayit as Map))
        .map(
          (kayit) => YaziciDurumuVarligi(
            id: kayit['id'] as String,
            ad: kayit['ad'] as String,
            rolEtiketi: kayit['rolEtiketi'] as String,
            baglantiNoktasi: kayit['baglantiNoktasi'] as String,
            aciklama: kayit['aciklama'] as String,
            durum: YaziciBaglantiDurumu.values[(kayit['durum'] as num).toInt()],
          ),
        )
        .toList();
  }

  Future<void> _yazicilariYaz(List<YaziciDurumuVarligi> yazicilar) async {
    final List<Map<String, Object?>> jsonaHazir = yazicilar
        .map(
          (yazici) => <String, Object?>{
            'id': yazici.id,
            'ad': yazici.ad,
            'rolEtiketi': yazici.rolEtiketi,
            'baglantiNoktasi': yazici.baglantiNoktasi,
            'aciklama': yazici.aciklama,
            'durum': yazici.durum.index,
          },
        )
        .toList();
    await _veritabani.ayarYaz(_yaziciVeriAnahtari, jsonEncode(jsonaHazir));
  }
}
