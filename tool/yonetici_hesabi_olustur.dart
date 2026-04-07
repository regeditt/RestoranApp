// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sqlite3/sqlite3.dart';

void main(List<String> argumanlar) {
  final String kullaniciAdi = argumanlar.isNotEmpty
      ? argumanlar[0].trim()
      : 'admin';
  final String adSoyad = argumanlar.length > 1
      ? argumanlar[1].trim()
      : 'Sistem Yonetici';

  String sifre = 'admin123';
  String? dbYolu;
  if (argumanlar.length > 2) {
    final String ucuncuArguman = argumanlar[2].trim();
    if (_dbYoluGibiGorunuyorMu(ucuncuArguman)) {
      dbYolu = ucuncuArguman;
    } else {
      sifre = ucuncuArguman;
    }
  }
  if (argumanlar.length > 3) {
    dbYolu = argumanlar[3].trim();
  }
  if (sifre.isEmpty) {
    throw StateError('Sifre bos olamaz.');
  }

  final File dbDosyasi = _dbDosyasiniHazirla(dbYolu);
  final Database veritabani = sqlite3.open(dbDosyasi.path);

  try {
    final ResultSet tabloDurumu = veritabani.select(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'kullanici_kayitlari'",
    );
    if (tabloDurumu.isEmpty) {
      throw StateError(
        'kullanici_kayitlari tablosu bulunamadi. Uygulamayi once en az bir kez acip veritabanini olustur.',
      );
    }
    veritabani.execute(
      'CREATE TABLE IF NOT EXISTS kullanici_giris_bilgileri ('
      'telefon TEXT NOT NULL PRIMARY KEY, '
      'sifre_hash TEXT NOT NULL, '
      'sifre_tuz TEXT NOT NULL, '
      'guncellenme_millis INTEGER NOT NULL'
      ')',
    );

    veritabani.execute('UPDATE kullanici_kayitlari SET aktif_mi = 0');
    final ResultSet mevcutKullanici = veritabani.select(
      'SELECT id FROM kullanici_kayitlari WHERE telefon = ? LIMIT 1',
      <Object?>[kullaniciAdi],
    );
    final String kayitAdSoyad = adSoyad.isEmpty ? kullaniciAdi : adSoyad;

    if (mevcutKullanici.isEmpty) {
      final ResultSet sonuc = veritabani.select(
        "SELECT COALESCE(MAX(CAST(id AS INTEGER)), 0) + 1 AS yeni_id "
        "FROM kullanici_kayitlari "
        "WHERE id GLOB '[0-9]*'",
      );
      final int yeniId = sonuc.first['yeni_id'] as int;
      veritabani.execute(
        'INSERT INTO kullanici_kayitlari '
        '(id, ad_soyad, telefon, eposta, rol, aktif_mi, adres_metni) '
        'VALUES (?, ?, ?, NULL, ?, 1, NULL)',
        <Object?>[yeniId.toString(), kayitAdSoyad, kullaniciAdi, 3],
      );
    } else {
      final String mevcutId = mevcutKullanici.first['id'] as String;
      veritabani.execute(
        'UPDATE kullanici_kayitlari '
        'SET ad_soyad = ?, rol = ?, aktif_mi = 1 '
        'WHERE id = ?',
        <Object?>[kayitAdSoyad, 3, mevcutId],
      );
    }

    final String sifreTuzu = _rastgeleTuzUret();
    final String sifreHash = _sifreHashle(sifre: sifre, tuz: sifreTuzu);
    veritabani.execute(
      'INSERT INTO kullanici_giris_bilgileri '
      '(telefon, sifre_hash, sifre_tuz, guncellenme_millis) '
      'VALUES (?, ?, ?, ?) '
      'ON CONFLICT(telefon) DO UPDATE SET '
      'sifre_hash = excluded.sifre_hash, '
      'sifre_tuz = excluded.sifre_tuz, '
      'guncellenme_millis = excluded.guncellenme_millis',
      <Object?>[
        kullaniciAdi,
        sifreHash,
        sifreTuzu,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );

    print('Yonetici hesabi olusturuldu.');
    print('Veritabani: ${dbDosyasi.path}');
    print('Kullanici adi: $kullaniciAdi');
    print('Sifre: $sifre');
    print('Rol: yonetici');
  } finally {
    veritabani.close();
  }
}

File _dbDosyasiniHazirla(String? dbYolu) {
  if (dbYolu != null && dbYolu.isNotEmpty) {
    final File dosya = File(dbYolu);
    dosya.parent.createSync(recursive: true);
    return dosya;
  }

  final String userProfile = Platform.environment['USERPROFILE'] ?? '';
  if (userProfile.isNotEmpty) {
    final File varsayilan = File(
      '$userProfile\\Documents\\restoran_app.sqlite',
    );
    varsayilan.parent.createSync(recursive: true);
    return varsayilan;
  }

  final File fallback = File('restoran_app.sqlite');
  fallback.parent.createSync(recursive: true);
  return fallback;
}

bool _dbYoluGibiGorunuyorMu(String deger) {
  final String kucuk = deger.toLowerCase();
  return deger.contains(r'\') ||
      deger.contains('/') ||
      kucuk.endsWith('.sqlite') ||
      kucuk.endsWith('.db');
}

String _rastgeleTuzUret([int uzunluk = 16]) {
  final Random rastgele = Random.secure();
  final List<int> byteDizisi = List<int>.generate(
    uzunluk,
    (_) => rastgele.nextInt(256),
  );
  return base64Url.encode(byteDizisi);
}

String _sifreHashle({required String sifre, required String tuz}) {
  final List<int> bytes = utf8.encode('$tuz:$sifre');
  return sha256.convert(bytes).toString();
}
