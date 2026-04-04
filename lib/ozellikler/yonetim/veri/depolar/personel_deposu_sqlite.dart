import 'dart:convert';

import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/personel_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class PersonelDeposuSqlite implements PersonelDeposu {
  PersonelDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;
  final PersonelDeposuMock _seedDeposu = PersonelDeposuMock();
  bool _seedKontrolEdildi = false;

  static const String _personelVeriAnahtari = 'yonetim_personel_v1';
  static const String _personelSeedAnahtari = 'yonetim_personel_seeded';

  @override
  Future<List<PersonelDurumuVarligi>> personelleriGetir() async {
    await _seedEminOl();
    final String? jsonVeri = await _veritabani.ayarOku(_personelVeriAnahtari);
    if (jsonVeri == null || jsonVeri.isEmpty) {
      return const <PersonelDurumuVarligi>[];
    }

    final dynamic ham = jsonDecode(jsonVeri);
    if (ham is! List) {
      return const <PersonelDurumuVarligi>[];
    }

    return ham
        .map((kayit) => Map<String, Object?>.from(kayit as Map))
        .map(
          (kayit) => PersonelDurumuVarligi(
            adSoyad: kayit['adSoyad'] as String,
            rolEtiketi: kayit['rolEtiketi'] as String,
            bolge: kayit['bolge'] as String,
            aciklama: kayit['aciklama'] as String,
            durum: PersonelDurumu.values[(kayit['durum'] as num).toInt()],
          ),
        )
        .toList();
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final String? seedDurumu = await _veritabani.ayarOku(_personelSeedAnahtari);
    if (seedDurumu == 'true') {
      _seedKontrolEdildi = true;
      return;
    }

    final List<PersonelDurumuVarligi> personeller =
        await _seedDeposu.personelleriGetir();
    final List<Map<String, Object?>> jsonaHazir = personeller
        .map(
          (personel) => <String, Object?>{
            'adSoyad': personel.adSoyad,
            'rolEtiketi': personel.rolEtiketi,
            'bolge': personel.bolge,
            'aciklama': personel.aciklama,
            'durum': personel.durum.index,
          },
        )
        .toList();

    await _veritabani.ayarYaz(_personelVeriAnahtari, jsonEncode(jsonaHazir));
    await _veritabani.ayarYaz(_personelSeedAnahtari, 'true');
    _seedKontrolEdildi = true;
  }
}
