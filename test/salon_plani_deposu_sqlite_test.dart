import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/salon_plani_deposu_sqlite.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

void main() {
  test(
    'SalonPlaniDeposuSqlite bos veritabanini varsayilan salon plani ile doldurur',
    () async {
      final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
        NativeDatabase.memory(),
      );
      addTearDown(veritabani.close);

      final SalonPlaniDeposuSqlite depo = SalonPlaniDeposuSqlite(veritabani);

      final bolumler = await depo.bolumleriGetir();

      expect(bolumler, isNotEmpty);
      expect(bolumler.first.masalar, isNotEmpty);
      expect(await veritabani.ayarOku('salon_plani_seeded'), 'true');
    },
  );

  test(
    'SalonPlaniDeposuSqlite yari kalmis salon verisini seed ile onarir',
    () async {
      final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
        NativeDatabase.memory(),
      );
      addTearDown(veritabani.close);

      await veritabani
          .into(veritabani.salonBolumKayitlari)
          .insert(
            const SalonBolumKayitlariCompanion(
              id: Value('1'),
              ad: Value('Eksik Salon'),
              aciklama: Value('Masalari olmayan eski veri'),
            ),
          );

      final SalonPlaniDeposuSqlite depo = SalonPlaniDeposuSqlite(veritabani);

      final bolumler = await depo.bolumleriGetir();

      expect(bolumler, hasLength(3));
      expect(bolumler.every((bolum) => bolum.masalar.isNotEmpty), isTrue);
      expect(bolumler.any((bolum) => bolum.ad == 'Eksik Salon'), isFalse);
    },
  );

  test('SalonPlaniDeposuSqlite mevcut tam salon verisini korur', () async {
    final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
      NativeDatabase.memory(),
    );
    addTearDown(veritabani.close);

    await veritabani
        .into(veritabani.salonBolumKayitlari)
        .insert(
          const SalonBolumKayitlariCompanion(
            id: Value('9'),
            ad: Value('VIP'),
            aciklama: Value('Hazir veri'),
          ),
        );
    await veritabani
        .into(veritabani.masaKayitlari)
        .insert(
          const MasaKayitlariCompanion(
            id: Value('11'),
            bolumId: Value('9'),
            ad: Value('V1'),
            kapasite: Value(6),
          ),
        );

    final SalonPlaniDeposuSqlite depo = SalonPlaniDeposuSqlite(veritabani);

    final bolumler = await depo.bolumleriGetir();

    expect(bolumler, hasLength(1));
    expect(bolumler.single.ad, 'VIP');
    expect(bolumler.single.masalar.single.ad, 'V1');
    expect(await veritabani.ayarOku('salon_plani_seeded'), 'true');
  });
}
