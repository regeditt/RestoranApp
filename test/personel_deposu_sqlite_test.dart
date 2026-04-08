import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/personel_deposu_sqlite.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

void main() {
  test('PersonelDeposuSqlite bagli giris hesabini da siler', () async {
    final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
      NativeDatabase.memory(),
    );
    addTearDown(veritabani.close);

    final KimlikDeposuSqlite kimlikDeposu = KimlikDeposuSqlite(veritabani);
    final PersonelDeposuSqlite personelDeposu = PersonelDeposuSqlite(
      veritabani,
    );

    final kullanici = await kimlikDeposu.hesapOlustur(
      telefon: 'garson_silinecek',
      sifre: '123456',
      adSoyad: 'Silinecek Garson',
      rol: KullaniciRolu.garson,
    );
    await veritabani.tumKullanicilariPasifYap();

    await personelDeposu.personelSil(kullanici.id);

    final kullaniciKaydi = await veritabani.kullaniciKimligeGoreGetir(
      kullanici.id,
    );
    final sifreBilgisi = await veritabani.kullaniciSifreBilgisiGetir(
      'garson_silinecek',
    );
    final personeller = await personelDeposu.personelleriGetir();

    expect(kullaniciKaydi, isNull);
    expect(sifreBilgisi, isNull);
    expect(
      personeller.any((personel) => personel.adSoyad == 'Silinecek Garson'),
      isFalse,
    );
  });
}
