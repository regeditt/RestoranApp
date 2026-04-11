import 'dart:convert';

import 'package:restoran_app/ozellikler/rezervasyon/alan/depolar/rezervasyon_deposu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/enumlar/rezervasyon_durumu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/varliklar/rezervasyon_varligi.dart';
import 'package:restoran_app/ozellikler/rezervasyon/veri/depolar/rezervasyon_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class RezervasyonDeposuSqlite implements RezervasyonDeposu {
  RezervasyonDeposuSqlite(this._veritabani);

  static const String _ayarAnahtari = 'rezervasyon_modulu_kayitlari_v1';
  static const String _seedAnahtari = 'rezervasyon_modulu_seed_v1';

  final UygulamaVeritabani _veritabani;
  final RezervasyonDeposuMock _seedDeposu = RezervasyonDeposuMock();
  List<RezervasyonVarligi> _kayitlar = <RezervasyonVarligi>[];
  bool _yuklendi = false;

  @override
  Future<void> rezervasyonDurumuGuncelle({
    required String rezervasyonId,
    required RezervasyonDurumu durum,
  }) async {
    await _yuklemeEminOl();
    final int index = _kayitlar.indexWhere(
      (kayit) => kayit.id == rezervasyonId,
    );
    if (index < 0) {
      return;
    }
    _kayitlar[index] = _kayitlar[index].copyWith(durum: durum);
    await _kaliciKaydet();
  }

  @override
  Future<void> rezervasyonKaydet(RezervasyonVarligi rezervasyon) async {
    await _yuklemeEminOl();
    final int index = _kayitlar.indexWhere(
      (kayit) => kayit.id == rezervasyon.id,
    );
    if (index < 0) {
      _kayitlar.add(rezervasyon);
    } else {
      _kayitlar[index] = rezervasyon;
    }
    await _kaliciKaydet();
  }

  @override
  Future<List<RezervasyonVarligi>> rezervasyonlariGetir({DateTime? gun}) async {
    await _yuklemeEminOl();
    Iterable<RezervasyonVarligi> sonuc = _kayitlar;
    if (gun != null) {
      final DateTime gunBaslangici = DateTime(gun.year, gun.month, gun.day);
      final DateTime gunBitisi = gunBaslangici.add(const Duration(days: 1));
      sonuc = sonuc.where((rezervasyon) {
        return rezervasyon.baslangicZamani.isBefore(gunBitisi) &&
            rezervasyon.bitisZamani.isAfter(gunBaslangici);
      });
    }
    final List<RezervasyonVarligi> sirali = sonuc.toList()
      ..sort((a, b) => a.baslangicZamani.compareTo(b.baslangicZamani));
    return sirali.map((kayit) => kayit.copyWith()).toList(growable: false);
  }

  @override
  Future<void> rezervasyonSil(String rezervasyonId) async {
    await _yuklemeEminOl();
    _kayitlar.removeWhere((kayit) => kayit.id == rezervasyonId);
    await _kaliciKaydet();
  }

  Future<void> _yuklemeEminOl() async {
    if (_yuklendi) {
      return;
    }

    final String? kayitJson = await _veritabani.ayarOku(_ayarAnahtari);
    if (kayitJson != null && kayitJson.trim().isNotEmpty) {
      _kayitlar = _jsondanCoz(kayitJson);
      _yuklendi = true;
      return;
    }

    final String? seedYazildi = await _veritabani.ayarOku(_seedAnahtari);
    if (seedYazildi == 'true') {
      _kayitlar = <RezervasyonVarligi>[];
      _yuklendi = true;
      return;
    }

    _kayitlar = await _seedDeposu.rezervasyonlariGetir();
    await _kaliciKaydet();
    await _veritabani.ayarYaz(_seedAnahtari, 'true');
    _yuklendi = true;
  }

  Future<void> _kaliciKaydet() async {
    final String jsonMetni = jsonEncode(
      _kayitlar.map(_jsonaDonustur).toList(growable: false),
    );
    await _veritabani.ayarYaz(_ayarAnahtari, jsonMetni);
  }

  List<RezervasyonVarligi> _jsondanCoz(String jsonVeri) {
    final dynamic ham = _guvenliJsonCoz(jsonVeri);
    if (ham is! List) {
      return <RezervasyonVarligi>[];
    }
    final List<RezervasyonVarligi> sonuc = <RezervasyonVarligi>[];
    for (final dynamic item in ham) {
      if (item is! Map) {
        continue;
      }
      final Map<String, Object?> kayit = Map<String, Object?>.from(item);
      final String id = (kayit['id'] as String? ?? '').trim();
      final String musteriAdi = (kayit['musteriAdi'] as String? ?? '').trim();
      final String telefon = (kayit['telefon'] as String? ?? '').trim();
      final int kisiSayisi = (kayit['kisiSayisi'] as num?)?.toInt() ?? 0;
      final DateTime? baslangicZamani = DateTime.tryParse(
        (kayit['baslangicZamani'] as String? ?? '').trim(),
      );
      final DateTime? bitisZamani = DateTime.tryParse(
        (kayit['bitisZamani'] as String? ?? '').trim(),
      );
      final DateTime? olusturmaZamani = DateTime.tryParse(
        (kayit['olusturmaZamani'] as String? ?? '').trim(),
      );
      if (id.isEmpty ||
          musteriAdi.isEmpty ||
          telefon.isEmpty ||
          kisiSayisi <= 0 ||
          baslangicZamani == null ||
          bitisZamani == null ||
          olusturmaZamani == null) {
        continue;
      }

      final int durumIndex = (kayit['durum'] as num?)?.toInt() ?? 0;
      final RezervasyonDurumu durum = RezervasyonDurumu
          .values[durumIndex.clamp(0, RezervasyonDurumu.values.length - 1)];

      sonuc.add(
        RezervasyonVarligi(
          id: id,
          musteriAdi: musteriAdi,
          telefon: telefon,
          kisiSayisi: kisiSayisi,
          baslangicZamani: baslangicZamani,
          bitisZamani: bitisZamani,
          durum: durum,
          olusturmaZamani: olusturmaZamani,
          bolumId: (kayit['bolumId'] as String?)?.trim(),
          bolumAdi: (kayit['bolumAdi'] as String?)?.trim(),
          masaId: (kayit['masaId'] as String?)?.trim(),
          masaAdi: (kayit['masaAdi'] as String?)?.trim(),
          notMetni: (kayit['notMetni'] as String? ?? '').trim(),
        ),
      );
    }
    return sonuc;
  }

  Map<String, Object?> _jsonaDonustur(RezervasyonVarligi rezervasyon) {
    return <String, Object?>{
      'id': rezervasyon.id,
      'musteriAdi': rezervasyon.musteriAdi,
      'telefon': rezervasyon.telefon,
      'kisiSayisi': rezervasyon.kisiSayisi,
      'baslangicZamani': rezervasyon.baslangicZamani.toIso8601String(),
      'bitisZamani': rezervasyon.bitisZamani.toIso8601String(),
      'durum': rezervasyon.durum.index,
      'olusturmaZamani': rezervasyon.olusturmaZamani.toIso8601String(),
      'bolumId': rezervasyon.bolumId,
      'bolumAdi': rezervasyon.bolumAdi,
      'masaId': rezervasyon.masaId,
      'masaAdi': rezervasyon.masaAdi,
      'notMetni': rezervasyon.notMetni,
    };
  }

  dynamic _guvenliJsonCoz(String jsonVeri) {
    try {
      return jsonDecode(jsonVeri);
    } catch (_) {
      return null;
    }
  }
}
