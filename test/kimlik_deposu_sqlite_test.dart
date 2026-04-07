import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/servisler/sifre_ozetleyici.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_sqlite.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

void main() {
  test('KimlikDeposuSqlite giriste tek aktif kullanici birakir', () async {
    final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
      NativeDatabase.memory(),
    );
    addTearDown(veritabani.close);
    final KimlikDeposuSqlite depo = KimlikDeposuSqlite(veritabani);
    await _kullaniciEkle(
      veritabani: veritabani,
      id: '1',
      telefon: 'garson',
      rol: KullaniciRolu.garson,
      adSoyad: 'Garson Deneme',
      sifre: '123456',
    );
    await _kullaniciEkle(
      veritabani: veritabani,
      id: '2',
      telefon: 'yonetici',
      rol: KullaniciRolu.yonetici,
      adSoyad: 'Yonetici Deneme',
      sifre: '123456',
    );

    await depo.girisYap(
      telefon: 'garson',
      sifre: '123456',
      rol: KullaniciRolu.garson,
      adSoyad: 'Garson Deneme',
    );
    await depo.girisYap(
      telefon: 'yonetici',
      sifre: '123456',
      rol: KullaniciRolu.yonetici,
      adSoyad: 'Yonetici Deneme',
    );

    final aktif = await depo.aktifKullaniciGetir();
    final tumKayitlar = await veritabani
        .select(veritabani.kullaniciKayitlari)
        .get();
    final aktifSayisi = tumKayitlar.where((k) => k.aktifMi).length;

    expect(aktif, isNotNull);
    expect(aktif?.telefon, 'yonetici');
    expect(aktif?.rol, KullaniciRolu.yonetici);
    expect(aktifSayisi, 1);
  });

  test('KimlikDeposuSqlite aktif kullanici yoksa null doner', () async {
    final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
      NativeDatabase.memory(),
    );
    addTearDown(veritabani.close);
    final KimlikDeposuSqlite depo = KimlikDeposuSqlite(veritabani);

    final aktif = await depo.aktifKullaniciGetir();

    expect(aktif, isNull);
  });

  test('KimlikDeposuSqlite yanlis sifre ile giris yapmaz', () async {
    final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
      NativeDatabase.memory(),
    );
    addTearDown(veritabani.close);
    final KimlikDeposuSqlite depo = KimlikDeposuSqlite(veritabani);
    await _kullaniciEkle(
      veritabani: veritabani,
      id: '1',
      telefon: 'admin',
      rol: KullaniciRolu.yonetici,
      adSoyad: 'Admin',
      sifre: 'dogru-sifre',
    );

    expect(
      () => depo.girisYap(
        telefon: 'admin',
        sifre: 'yanlis-sifre',
        rol: KullaniciRolu.yonetici,
      ),
      throwsA(isA<StateError>()),
    );
  });
}

Future<void> _kullaniciEkle({
  required UygulamaVeritabani veritabani,
  required String id,
  required String telefon,
  required String sifre,
  required KullaniciRolu rol,
  required String adSoyad,
}) async {
  await veritabani.kullaniciKaydet(
    KullaniciVarligi(
      id: id,
      adSoyad: adSoyad,
      telefon: telefon,
      rol: rol,
      aktifMi: false,
    ),
  );

  final SifreOzeti sifreOzeti = const SifreOzetleyici().ozetOlustur(sifre);
  await veritabani.kullaniciSifreBilgisiKaydet(
    telefon: telefon,
    sifreHash: sifreOzeti.hash,
    sifreTuz: sifreOzeti.tuz,
  );
}
