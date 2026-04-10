import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kurye_takip/uygulama/servisler/kurye_takip_saglayici_kayit_defteri.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/kurye_entegrasyon_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

void main() {
  test(
    'KuryeEntegrasyonYonetimServisi varsayilan saglayicilarda Traccar Navix ve Turk 1-5 bulunur',
    () async {
      final KuryeEntegrasyonYonetimServisi servis =
          KuryeEntegrasyonYonetimServisi();
      final List<KuryeTakipSaglayiciVarligi> saglayicilar = await servis
          .saglayicilariGetir();
      final Set<String> ids = saglayicilar.map((e) => e.id).toSet();

      expect(ids.contains('sgl_traccar'), isTrue);
      expect(ids.contains('sgl_navix'), isTrue);
      expect(ids.contains('sgl_turk_1'), isTrue);
      expect(ids.contains('sgl_turk_2'), isTrue);
      expect(ids.contains('sgl_turk_3'), isTrue);
      expect(ids.contains('sgl_turk_4'), isTrue);
      expect(ids.contains('sgl_turk_5'), isTrue);
      expect(saglayicilar.where((kayit) => kayit.aktifMi).length, 1);
    },
  );

  test(
    'KuryeEntegrasyonYonetimServisi tek bir aktif saglayici korur',
    () async {
      final KuryeEntegrasyonYonetimServisi servis =
          KuryeEntegrasyonYonetimServisi(
            baslangicSaglayicilar: <KuryeTakipSaglayiciVarligi>[
              const KuryeTakipSaglayiciVarligi(
                id: 'sgl_1',
                ad: 'Bir',
                tur: KuryeTakipSaglayiciTuru.ozelApi,
                apiTabanUrl: 'https://bir.example.com',
                apiAnahtari: 'a1',
                aktifMi: true,
                oncelik: 1,
                aciklama: 'Birinci',
              ),
              const KuryeTakipSaglayiciVarligi(
                id: 'sgl_2',
                ad: 'Iki',
                tur: KuryeTakipSaglayiciTuru.traccar,
                apiTabanUrl: 'https://iki.example.com',
                apiAnahtari: 'a2',
                aktifMi: false,
                oncelik: 2,
                aciklama: 'Ikinci',
              ),
            ],
          );

      await servis.aktifSaglayiciYap('sgl_2');
      final List<KuryeTakipSaglayiciVarligi> saglayicilar = await servis
          .saglayicilariGetir();

      expect(saglayicilar.where((kayit) => kayit.aktifMi).length, 1);
      expect(saglayicilar.firstWhere((kayit) => kayit.aktifMi).id, 'sgl_2');
    },
  );

  test('KuryeEntegrasyonYonetimServisi oncelik degisimini uygular', () async {
    final KuryeEntegrasyonYonetimServisi servis =
        KuryeEntegrasyonYonetimServisi(
          baslangicSaglayicilar: <KuryeTakipSaglayiciVarligi>[
            const KuryeTakipSaglayiciVarligi(
              id: 'sgl_1',
              ad: 'Bir',
              tur: KuryeTakipSaglayiciTuru.ozelApi,
              apiTabanUrl: 'https://bir.example.com',
              apiAnahtari: 'a1',
              aktifMi: true,
              oncelik: 1,
              aciklama: 'Birinci',
            ),
            const KuryeTakipSaglayiciVarligi(
              id: 'sgl_2',
              ad: 'Iki',
              tur: KuryeTakipSaglayiciTuru.traccar,
              apiTabanUrl: 'https://iki.example.com',
              apiAnahtari: 'a2',
              aktifMi: false,
              oncelik: 2,
              aciklama: 'Ikinci',
            ),
          ],
        );

    await servis.saglayiciOnceligiDegistir(saglayiciId: 'sgl_2', yukari: true);
    final List<KuryeTakipSaglayiciVarligi> saglayicilar = await servis
        .saglayicilariGetir();

    expect(saglayicilar.first.id, 'sgl_2');
    expect(saglayicilar.first.oncelik, 1);
    expect(saglayicilar.last.oncelik, 2);
  });

  test(
    'KuryeEntegrasyonYonetimServisi saglayici silince bagli eslesmeleri de temizler',
    () async {
      final KuryeEntegrasyonYonetimServisi servis =
          KuryeEntegrasyonYonetimServisi(
            baslangicSaglayicilar: <KuryeTakipSaglayiciVarligi>[
              const KuryeTakipSaglayiciVarligi(
                id: 'sgl_1',
                ad: 'Bir',
                tur: KuryeTakipSaglayiciTuru.ozelApi,
                apiTabanUrl: 'https://bir.example.com',
                apiAnahtari: 'a1',
                aktifMi: true,
                oncelik: 1,
                aciklama: 'Birinci',
              ),
            ],
            baslangicEslesmeler: const <KuryeCihazEslesmesiVarligi>[
              KuryeCihazEslesmesiVarligi(
                kuryeAdi: 'Emre Kurye',
                saglayiciId: 'sgl_1',
                cihazKimligi: 'IMEI-111',
                aktifMi: true,
              ),
            ],
          );

      await servis.saglayiciSil('sgl_1');
      final List<KuryeCihazEslesmesiVarligi> eslesmeler = await servis
          .kuryeCihazEslesmeleriniGetir();

      expect(eslesmeler, isEmpty);
    },
  );

  test(
    'KuryeEntegrasyonYonetimServisi sqlite ile saglayici ve eslesmeleri kalici tutar',
    () async {
      final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
        NativeDatabase.memory(),
      );
      addTearDown(veritabani.close);

      final KuryeEntegrasyonYonetimServisi ilkServis =
          KuryeEntegrasyonYonetimServisi(
            depo: KuryeEntegrasyonDeposuSqlite(veritabani),
            baslangicSaglayicilar: const <KuryeTakipSaglayiciVarligi>[
              KuryeTakipSaglayiciVarligi(
                id: 'sgl_1',
                ad: 'Bir',
                tur: KuryeTakipSaglayiciTuru.ozelApi,
                apiTabanUrl: 'https://bir.example.com',
                apiAnahtari: 'a1',
                aktifMi: true,
                oncelik: 1,
                aciklama: 'Birinci',
              ),
            ],
          );
      await ilkServis.saglayicilariGetir();
      await ilkServis.kuryeCihazEslesmesiKaydet(
        const KuryeCihazEslesmesiVarligi(
          kuryeAdi: 'Emre Kurye',
          saglayiciId: 'sgl_1',
          cihazKimligi: 'IMEI-111',
          aktifMi: true,
        ),
      );

      final KuryeEntegrasyonYonetimServisi ikinciServis =
          KuryeEntegrasyonYonetimServisi(
            depo: KuryeEntegrasyonDeposuSqlite(veritabani),
            baslangicSaglayicilar: const <KuryeTakipSaglayiciVarligi>[],
          );
      // Ayni veritabaniyla yeniden acildiginda kalici kayitlar geri gelmeli.
      final List<KuryeTakipSaglayiciVarligi> saglayicilar = await ikinciServis
          .saglayicilariGetir();
      final List<KuryeCihazEslesmesiVarligi> eslesmeler = await ikinciServis
          .kuryeCihazEslesmeleriniGetir();

      final Set<String> ids = saglayicilar.map((kayit) => kayit.id).toSet();
      expect(ids.contains('sgl_1'), isTrue);
      expect(ids.contains('sgl_traccar'), isTrue);
      expect(eslesmeler.length, 1);
      expect(eslesmeler.first.kuryeAdi, 'Emre Kurye');
    },
  );

  test(
    'KuryeEntegrasyonYonetimServisi eski sqlite kaydina eksik varsayilan saglayicilari ekler',
    () async {
      final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
        NativeDatabase.memory(),
      );
      addTearDown(veritabani.close);

      // Eski surumde sadece dahili kayit varken yeni varsayilanlar merge edilmeli.
      final String eskiJson = jsonEncode(<Map<String, Object?>>[
        <String, Object?>{
          'id': 'sgl_dahili',
          'ad': 'Dahili Cihaz GPS',
          'tur': KuryeTakipSaglayiciTuru.dahiliGps.index,
          'apiTabanUrl': 'https://lokal-cihaz-gps',
          'apiAnahtari': 'cihaz-izinli',
          'aktifMi': true,
          'oncelik': 1,
          'aciklama': 'Kurye telefonunun dahili GPS akisindan konum alir.',
        },
      ]);
      await veritabani.ayarYaz('kurye_takip_saglayicilar_v1', eskiJson);
      await veritabani.ayarYaz('kurye_takip_eslesmeler_v1', '[]');

      final KuryeEntegrasyonYonetimServisi servis =
          KuryeEntegrasyonYonetimServisi(
            depo: KuryeEntegrasyonDeposuSqlite(veritabani),
          );
      final List<KuryeTakipSaglayiciVarligi> saglayicilar = await servis
          .saglayicilariGetir();
      final Set<String> ids = saglayicilar.map((e) => e.id).toSet();

      expect(ids.contains('sgl_dahili'), isTrue);
      expect(ids.contains('sgl_traccar'), isTrue);
      expect(ids.contains('sgl_navix'), isTrue);
      expect(ids.contains('sgl_turk_1'), isTrue);
      expect(ids.contains('sgl_turk_5'), isTrue);
    },
  );

  test(
    'KuryeEntegrasyonYonetimServisi aktif eslesmeden takip kimligi uretir',
    () async {
      final KuryeEntegrasyonYonetimServisi servis =
          KuryeEntegrasyonYonetimServisi(
            baslangicSaglayicilar: const <KuryeTakipSaglayiciVarligi>[
              KuryeTakipSaglayiciVarligi(
                id: 'sgl_1',
                ad: 'Bir',
                tur: KuryeTakipSaglayiciTuru.traccar,
                apiTabanUrl: 'https://bir.example.com',
                apiAnahtari: 'a1',
                aktifMi: true,
                oncelik: 1,
                aciklama: 'Birinci',
              ),
            ],
            baslangicEslesmeler: const <KuryeCihazEslesmesiVarligi>[
              KuryeCihazEslesmesiVarligi(
                kuryeAdi: 'Emre Kurye',
                saglayiciId: 'sgl_1',
                cihazKimligi: 'IMEI-111',
                aktifMi: true,
              ),
            ],
          );

      final String? takipKimligi = await servis.kuryeTakipKimligiGetir(
        'Emre Kurye',
      );

      expect(takipKimligi, 'sgl_1:IMEI-111');
    },
  );

  test(
    'KuryeEntegrasyonYonetimServisi adaptor yoksa testte anlamli hata dondurur',
    () async {
      // Bos kayit defteri ile adaptor eksikligi senaryosu taklit edilir.
      final KuryeEntegrasyonYonetimServisi servis =
          KuryeEntegrasyonYonetimServisi(
            saglayiciKayitDefteri: KuryeTakipSaglayiciKayitDefteri(
              saglayicilar: const [],
            ),
            baslangicSaglayicilar: const <KuryeTakipSaglayiciVarligi>[
              KuryeTakipSaglayiciVarligi(
                id: 'sgl_1',
                ad: 'Bir',
                tur: KuryeTakipSaglayiciTuru.traccar,
                apiTabanUrl: 'https://bir.example.com',
                apiAnahtari: 'a1',
                aktifMi: true,
                oncelik: 1,
                aciklama: 'Birinci',
              ),
            ],
          );

      final KuryeSaglayiciTestSonucu sonuc = await servis.baglantiTestEt(
        'sgl_1',
      );

      expect(sonuc.basarili, isFalse);
      expect(sonuc.mesaj, contains('adaptor bulunamadi'));
    },
  );
}
