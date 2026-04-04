import 'dart:convert';

import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/salon_plani_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class SalonPlaniDeposuSqlite implements SalonPlaniDeposu {
  SalonPlaniDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;
  final SalonPlaniDeposuMock _seedDeposu = SalonPlaniDeposuMock();
  bool _seedKontrolEdildi = false;

  static const String _salonVeriAnahtari = 'yonetim_salon_plani_v1';
  static const String _salonSeedAnahtari = 'yonetim_salon_plani_seeded';

  @override
  Future<List<SalonBolumuVarligi>> bolumleriGetir() async {
    await _seedEminOl();
    return _bolumleriOku();
  }

  @override
  Future<void> bolumEkle(SalonBolumuVarligi bolum) async {
    await _seedEminOl();
    final List<SalonBolumuVarligi> bolumler = await _bolumleriOku();
    bolumler.add(bolum);
    await _bolumleriYaz(bolumler);
  }

  @override
  Future<void> bolumGuncelle(SalonBolumuVarligi bolum) async {
    await _seedEminOl();
    final List<SalonBolumuVarligi> bolumler = await _bolumleriOku();
    final int index = bolumler.indexWhere(
      (SalonBolumuVarligi kayit) => kayit.id == bolum.id,
    );
    if (index < 0) {
      return;
    }
    bolumler[index] = bolum;
    await _bolumleriYaz(bolumler);
  }

  @override
  Future<void> bolumSil(String bolumId) async {
    await _seedEminOl();
    final List<SalonBolumuVarligi> bolumler = await _bolumleriOku();
    bolumler.removeWhere((SalonBolumuVarligi bolum) => bolum.id == bolumId);
    await _bolumleriYaz(bolumler);
  }

  @override
  Future<void> masaEkle(String bolumId, MasaTanimiVarligi masa) async {
    await _seedEminOl();
    final List<SalonBolumuVarligi> bolumler = await _bolumleriOku();
    final int index = bolumler.indexWhere(
      (SalonBolumuVarligi bolum) => bolum.id == bolumId,
    );
    if (index < 0) {
      return;
    }
    final SalonBolumuVarligi bolum = bolumler[index];
    bolumler[index] = bolum.copyWith(
      masalar: <MasaTanimiVarligi>[...bolum.masalar, masa],
    );
    await _bolumleriYaz(bolumler);
  }

  @override
  Future<void> masaGuncelle({
    required String bolumId,
    required MasaTanimiVarligi masa,
  }) async {
    await _seedEminOl();
    final List<SalonBolumuVarligi> bolumler = await _bolumleriOku();
    final int index = bolumler.indexWhere(
      (SalonBolumuVarligi bolum) => bolum.id == bolumId,
    );
    if (index < 0) {
      return;
    }
    final SalonBolumuVarligi bolum = bolumler[index];
    bolumler[index] = bolum.copyWith(
      masalar: bolum.masalar
          .map((MasaTanimiVarligi kayit) => kayit.id == masa.id ? masa : kayit)
          .toList(),
    );
    await _bolumleriYaz(bolumler);
  }

  @override
  Future<void> masaSil({
    required String bolumId,
    required String masaId,
  }) async {
    await _seedEminOl();
    final List<SalonBolumuVarligi> bolumler = await _bolumleriOku();
    final int index = bolumler.indexWhere(
      (SalonBolumuVarligi bolum) => bolum.id == bolumId,
    );
    if (index < 0) {
      return;
    }
    final SalonBolumuVarligi bolum = bolumler[index];
    bolumler[index] = bolum.copyWith(
      masalar: bolum.masalar
          .where((MasaTanimiVarligi masa) => masa.id != masaId)
          .toList(),
    );
    await _bolumleriYaz(bolumler);
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final String? seedDurumu = await _veritabani.ayarOku(_salonSeedAnahtari);
    if (seedDurumu == 'true') {
      _seedKontrolEdildi = true;
      return;
    }

    final List<SalonBolumuVarligi> bolumler = await _seedDeposu.bolumleriGetir();
    await _bolumleriYaz(bolumler);
    await _veritabani.ayarYaz(_salonSeedAnahtari, 'true');
    _seedKontrolEdildi = true;
  }

  Future<List<SalonBolumuVarligi>> _bolumleriOku() async {
    final String? jsonVeri = await _veritabani.ayarOku(_salonVeriAnahtari);
    if (jsonVeri == null || jsonVeri.isEmpty) {
      return <SalonBolumuVarligi>[];
    }

    final dynamic ham = jsonDecode(jsonVeri);
    if (ham is! List) {
      return <SalonBolumuVarligi>[];
    }

    return ham
        .map((kayit) => Map<String, Object?>.from(kayit as Map))
        .map((kayit) {
          final List<dynamic> masalarHam =
              (kayit['masalar'] as List<dynamic>? ?? const <dynamic>[]);
          final List<MasaTanimiVarligi> masalar = masalarHam
              .map((masa) => Map<String, Object?>.from(masa as Map))
              .map(
                (masa) => MasaTanimiVarligi(
                  id: masa['id'] as String,
                  ad: masa['ad'] as String,
                  kapasite: (masa['kapasite'] as num).toInt(),
                ),
              )
              .toList();

          return SalonBolumuVarligi(
            id: kayit['id'] as String,
            ad: kayit['ad'] as String,
            aciklama: kayit['aciklama'] as String,
            masalar: masalar,
          );
        })
        .toList();
  }

  Future<void> _bolumleriYaz(List<SalonBolumuVarligi> bolumler) async {
    final List<Map<String, Object?>> jsonaHazir = bolumler
        .map(
          (bolum) => <String, Object?>{
            'id': bolum.id,
            'ad': bolum.ad,
            'aciklama': bolum.aciklama,
            'masalar': bolum.masalar
                .map(
                  (masa) => <String, Object?>{
                    'id': masa.id,
                    'ad': masa.ad,
                    'kapasite': masa.kapasite,
                  },
                )
                .toList(),
          },
        )
        .toList();

    await _veritabani.ayarYaz(_salonVeriAnahtari, jsonEncode(jsonaHazir));
  }
}
