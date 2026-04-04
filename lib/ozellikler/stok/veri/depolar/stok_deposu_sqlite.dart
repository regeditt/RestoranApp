import 'dart:convert';

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

  static const String _stokVeriAnahtari = 'stok_veri_v1';
  static const String _stokSeedAnahtari = 'stok_seeded';

  @override
  Future<List<HammaddeStokVarligi>> hammaddeleriGetir() async {
    await _seedEminOl();
    final _StokVeri veri = await _veriyiOku();
    return veri.hammaddeler;
  }

  @override
  Future<List<ReceteKalemiVarligi>> receteyiGetir(String urunId) async {
    await _seedEminOl();
    final _StokVeri veri = await _veriyiOku();
    return veri.receteler[urunId] ?? const <ReceteKalemiVarligi>[];
  }

  @override
  Future<void> receteyiKaydet(
    String urunId,
    List<ReceteKalemiVarligi> recete,
  ) async {
    await _seedEminOl();
    final _StokVeri veri = await _veriyiOku();
    final Map<String, List<ReceteKalemiVarligi>> receteler =
        <String, List<ReceteKalemiVarligi>>{
      ...veri.receteler,
      urunId: List<ReceteKalemiVarligi>.from(recete),
    };
    await _veriyiYaz(
      hammaddeler: veri.hammaddeler,
      receteler: receteler,
    );
  }

  @override
  Future<void> hammaddeEkle(HammaddeStokVarligi hammadde) async {
    await _seedEminOl();
    final _StokVeri veri = await _veriyiOku();
    final List<HammaddeStokVarligi> hammaddeler =
        List<HammaddeStokVarligi>.from(veri.hammaddeler)..add(hammadde);
    await _veriyiYaz(
      hammaddeler: hammaddeler,
      receteler: veri.receteler,
    );
  }

  @override
  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde) async {
    await _seedEminOl();
    final _StokVeri veri = await _veriyiOku();
    final List<HammaddeStokVarligi> hammaddeler =
        List<HammaddeStokVarligi>.from(veri.hammaddeler);
    final int index = hammaddeler.indexWhere(
      (HammaddeStokVarligi kayit) => kayit.id == hammadde.id,
    );
    if (index < 0) {
      return;
    }
    hammaddeler[index] = hammadde;
    await _veriyiYaz(
      hammaddeler: hammaddeler,
      receteler: veri.receteler,
    );
  }

  @override
  Future<void> stokDus({required String hammaddeId, required double miktar}) async {
    await _seedEminOl();
    final _StokVeri veri = await _veriyiOku();
    final List<HammaddeStokVarligi> hammaddeler =
        List<HammaddeStokVarligi>.from(veri.hammaddeler);
    final int index = hammaddeler.indexWhere(
      (HammaddeStokVarligi hammadde) => hammadde.id == hammaddeId,
    );
    if (index < 0) {
      return;
    }
    final HammaddeStokVarligi mevcut = hammaddeler[index];
    final double yeniMiktar =
        (mevcut.mevcutMiktar - miktar).clamp(0, double.infinity);
    hammaddeler[index] = mevcut.copyWith(mevcutMiktar: yeniMiktar);
    await _veriyiYaz(
      hammaddeler: hammaddeler,
      receteler: veri.receteler,
    );
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final String? seedDurumu = await _veritabani.ayarOku(_stokSeedAnahtari);
    if (seedDurumu == 'true') {
      _seedKontrolEdildi = true;
      return;
    }

    final List<HammaddeStokVarligi> hammaddeler =
        await _seedDeposu.hammaddeleriGetir();
    final receteler = <String, List<ReceteKalemiVarligi>>{};
    final urunler = await _seedSaglayici.urunleriGetir();
    for (final urun in urunler) {
      final List<ReceteKalemiVarligi> recete = await _seedDeposu.receteyiGetir(
        urun.id,
      );
      if (recete.isNotEmpty) {
        receteler[urun.id] = recete;
      }
    }

    await _veriyiYaz(hammaddeler: hammaddeler, receteler: receteler);
    await _veritabani.ayarYaz(_stokSeedAnahtari, 'true');
    _seedKontrolEdildi = true;
  }

  Future<_StokVeri> _veriyiOku() async {
    final String? jsonVeri = await _veritabani.ayarOku(_stokVeriAnahtari);
    if (jsonVeri == null || jsonVeri.isEmpty) {
      return const _StokVeri.bos();
    }

    final dynamic ham = jsonDecode(jsonVeri);
    if (ham is! Map) {
      return const _StokVeri.bos();
    }
    return _StokVeri.mapten(Map<String, Object?>.from(ham as Map));
  }

  Future<void> _veriyiYaz({
    required List<HammaddeStokVarligi> hammaddeler,
    required Map<String, List<ReceteKalemiVarligi>> receteler,
  }) async {
    final Map<String, Object?> veri = <String, Object?>{
      'hammaddeler': hammaddeler
          .map(
            (hammadde) => <String, Object?>{
              'id': hammadde.id,
              'ad': hammadde.ad,
              'birim': hammadde.birim,
              'mevcutMiktar': hammadde.mevcutMiktar,
              'kritikEsik': hammadde.kritikEsik,
              'birimMaliyet': hammadde.birimMaliyet,
            },
          )
          .toList(),
      'receteler': receteler.map(
        (urunId, kalemler) => MapEntry<String, Object?>(
          urunId,
          kalemler
              .map(
                (kalem) => <String, Object?>{
                  'hammaddeId': kalem.hammaddeId,
                  'miktar': kalem.miktar,
                },
              )
              .toList(),
        ),
      ),
    };

    await _veritabani.ayarYaz(_stokVeriAnahtari, jsonEncode(veri));
  }
}

class _StokVeri {
  const _StokVeri({
    required this.hammaddeler,
    required this.receteler,
  });

  const _StokVeri.bos()
      : hammaddeler = const <HammaddeStokVarligi>[],
        receteler = const <String, List<ReceteKalemiVarligi>>{};

  final List<HammaddeStokVarligi> hammaddeler;
  final Map<String, List<ReceteKalemiVarligi>> receteler;

  factory _StokVeri.mapten(Map<String, Object?> veri) {
    final List<dynamic> hammaddelerHam =
        (veri['hammaddeler'] as List<dynamic>? ?? const <dynamic>[]);
    final Map<String, dynamic> recetelerHam =
        Map<String, dynamic>.from(veri['receteler'] as Map? ?? const <String, dynamic>{});

    final List<HammaddeStokVarligi> hammaddeler = hammaddelerHam
        .map((ham) => Map<String, Object?>.from(ham as Map))
        .map(
          (ham) => HammaddeStokVarligi(
            id: ham['id'] as String,
            ad: ham['ad'] as String,
            birim: ham['birim'] as String,
            mevcutMiktar: (ham['mevcutMiktar'] as num).toDouble(),
            kritikEsik: (ham['kritikEsik'] as num).toDouble(),
            birimMaliyet: (ham['birimMaliyet'] as num).toDouble(),
          ),
        )
        .toList();

    final Map<String, List<ReceteKalemiVarligi>> receteler =
        <String, List<ReceteKalemiVarligi>>{};
    for (final MapEntry<String, dynamic> giris in recetelerHam.entries) {
      final List<dynamic> kalemlerHam =
          (giris.value as List<dynamic>? ?? const <dynamic>[]);
      receteler[giris.key] = kalemlerHam
          .map((ham) => Map<String, Object?>.from(ham as Map))
          .map(
            (ham) => ReceteKalemiVarligi(
              hammaddeId: ham['hammaddeId'] as String,
              miktar: (ham['miktar'] as num).toDouble(),
            ),
          )
          .toList();
    }

    return _StokVeri(hammaddeler: hammaddeler, receteler: receteler);
  }
}
