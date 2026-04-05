import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_baslatma.dart';
import 'package:restoran_app/ortak/veri/veritabani_baglanti.dart';

part 'veritabani.g.dart';

class KullaniciKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get adSoyad => text()();
  TextColumn get telefon => text()();
  TextColumn get eposta => text().nullable()();
  IntColumn get rol => integer()();
  BoolColumn get aktifMi => boolean()();
  TextColumn get adresMetni => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MisafirKayitlari extends Table {
  TextColumn get adSoyad => text()();
  TextColumn get telefon => text()();
  TextColumn get eposta => text().nullable()();
  TextColumn get adres => text().nullable()();

  @override
  Set<Column> get primaryKey => {telefon};
}

class KategoriKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get ad => text()();
  IntColumn get sira => integer()();
  BoolColumn get acikMi => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class UrunKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get kategoriId =>
      text().references(KategoriKayitlari, #id, onDelete: KeyAction.cascade)();
  TextColumn get ad => text()();
  TextColumn get aciklama => text()();
  RealColumn get fiyat => real()();
  TextColumn get gorselUrl => text().nullable()();
  BoolColumn get stoktaMi => boolean()();
  BoolColumn get oneCikanMi => boolean()();
  TextColumn get seceneklerJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SepetKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get kuponKodu => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SepetKalemleri extends Table {
  TextColumn get id => text()();
  TextColumn get sepetId =>
      text().references(SepetKayitlari, #id, onDelete: KeyAction.cascade)();
  TextColumn get urunId =>
      text().references(UrunKayitlari, #id, onDelete: KeyAction.cascade)();
  RealColumn get birimFiyat => real()();
  IntColumn get adet => integer()();
  TextColumn get secenekAdi => text().nullable()();
  TextColumn get notMetni => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SiparisKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get siparisNo => text()();
  IntColumn get teslimatTipi => integer()();
  IntColumn get durum => integer()();
  DateTimeColumn get olusturmaTarihi => dateTime()();
  TextColumn get adresMetni => text().nullable()();
  TextColumn get teslimatNotu => text().nullable()();
  TextColumn get kuryeAdi => text().nullable()();
  IntColumn get paketTeslimatDurumu => integer().nullable()();
  TextColumn get masaNo => text().nullable()();
  TextColumn get bolumAdi => text().nullable()();
  TextColumn get kaynak => text().nullable()();
  BoolColumn get sahipMisafir => boolean()();
  TextColumn get sahipAdSoyad => text()();
  TextColumn get sahipTelefon => text()();
  TextColumn get sahipEposta => text().nullable()();
  TextColumn get sahipAdres => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SiparisKalemleri extends Table {
  TextColumn get id => text()();
  TextColumn get siparisId =>
      text().references(SiparisKayitlari, #id, onDelete: KeyAction.cascade)();
  TextColumn get urunId => text()();
  TextColumn get urunAdi => text()();
  RealColumn get birimFiyat => real()();
  IntColumn get adet => integer()();
  TextColumn get secenekAdi => text().nullable()();
  TextColumn get notMetni => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UygulamaAyarlar extends Table {
  TextColumn get anahtar => text()();
  TextColumn get deger => text()();

  @override
  Set<Column> get primaryKey => {anahtar};
}

class YaziciKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get ad => text()();
  TextColumn get rolEtiketi => text()();
  TextColumn get baglantiNoktasi => text()();
  TextColumn get aciklama => text()();
  IntColumn get durum => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class PersonelKayitlari extends Table {
  TextColumn get kimlik => text()();
  TextColumn get adSoyad => text()();
  TextColumn get rolEtiketi => text()();
  TextColumn get bolge => text()();
  TextColumn get aciklama => text()();
  IntColumn get durum => integer()();

  @override
  Set<Column> get primaryKey => {kimlik};
}

class SalonBolumKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get ad => text()();
  TextColumn get aciklama => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class MasaKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get bolumId => text().references(
    SalonBolumKayitlari,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get ad => text()();
  IntColumn get kapasite => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class HammaddeKayitlari extends Table {
  TextColumn get id => text()();
  TextColumn get ad => text()();
  TextColumn get birim => text()();
  RealColumn get mevcutMiktar => real()();
  RealColumn get kritikEsik => real()();
  RealColumn get birimMaliyet => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReceteKalemKayitlari extends Table {
  TextColumn get urunId =>
      text().references(UrunKayitlari, #id, onDelete: KeyAction.cascade)();
  TextColumn get hammaddeId =>
      text().references(HammaddeKayitlari, #id, onDelete: KeyAction.cascade)();
  RealColumn get miktar => real()();

  @override
  Set<Column> get primaryKey => {urunId, hammaddeId};
}

@DriftDatabase(
  tables: [
    KullaniciKayitlari,
    MisafirKayitlari,
    KategoriKayitlari,
    UrunKayitlari,
    SepetKayitlari,
    SepetKalemleri,
    SiparisKayitlari,
    SiparisKalemleri,
    UygulamaAyarlar,
    YaziciKayitlari,
    PersonelKayitlari,
    SalonBolumKayitlari,
    MasaKayitlari,
    HammaddeKayitlari,
    ReceteKalemKayitlari,
  ],
)
class UygulamaVeritabani extends _$UygulamaVeritabani
    implements VeriKaynagiBaslatma {
  UygulamaVeritabani() : super(_baglanti());
  static final RegExp _sayisalKimlikDeseni = RegExp(r'^\d+$');

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _indeksleriOlustur();
      await _eskiJsonVerisiniYeniTablolaraTasi();
    },
    onUpgrade: (migrator, from, to) async {
      await migrator.createAll();
      await _indeksleriOlustur();
      if (from < 5) {
        await _eskiJsonVerisiniYeniTablolaraTasi();
      }
      if (from < 6) {
        await _tumKimlikleriNumeriklestir(migrator);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  @override
  Future<void> baslat() async {
    await customSelect('SELECT 1').get();
  }

  @override
  Future<void> kapat() async {
    await close();
  }

  Future<String> numerikKimlikCozumle({
    required String tabloAdi,
    String kimlikKolonu = 'id',
    required String adayKimlik,
  }) async {
    final String temizKimlik = adayKimlik.trim();
    if (_sayisalKimlikDeseni.hasMatch(temizKimlik)) {
      return temizKimlik;
    }
    return sonrakiNumerikKimlikGetir(
      tabloAdi: tabloAdi,
      kimlikKolonu: kimlikKolonu,
    );
  }

  Future<String> sonrakiNumerikKimlikGetir({
    required String tabloAdi,
    String kimlikKolonu = 'id',
  }) async {
    final satir = await customSelect(
      'SELECT COALESCE(MAX(CAST($kimlikKolonu AS INTEGER)), 0) + 1 AS sonraki '
      'FROM $tabloAdi '
      "WHERE $kimlikKolonu GLOB '[0-9]*'",
    ).getSingle();
    final int sonraki = satir.read<int>('sonraki');
    return sonraki.toString();
  }

  Future<void> kullaniciKaydet(KullaniciVarligi kullanici) async {
    await into(kullaniciKayitlari).insertOnConflictUpdate(
      KullaniciKayitlariCompanion(
        id: Value(kullanici.id),
        adSoyad: Value(kullanici.adSoyad),
        telefon: Value(kullanici.telefon),
        eposta: Value(kullanici.eposta),
        rol: Value(kullanici.rol.index),
        aktifMi: Value(kullanici.aktifMi),
        adresMetni: Value(kullanici.adresMetni),
      ),
    );
  }

  Future<void> ayarYaz(String anahtar, String deger) async {
    await into(uygulamaAyarlar).insertOnConflictUpdate(
      UygulamaAyarlarCompanion(anahtar: Value(anahtar), deger: Value(deger)),
    );
  }

  Future<String?> ayarOku(String anahtar) async {
    final kayit = await (select(
      uygulamaAyarlar,
    )..where((tbl) => tbl.anahtar.equals(anahtar))).getSingleOrNull();
    return kayit?.deger;
  }

  Future<KullaniciVarligi?> aktifKullaniciGetir() async {
    final kayit = await (select(
      kullaniciKayitlari,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.aktifMi)])).getSingleOrNull();
    if (kayit == null) return null;
    return KullaniciVarligi(
      id: kayit.id,
      adSoyad: kayit.adSoyad,
      telefon: kayit.telefon,
      eposta: kayit.eposta,
      rol: KullaniciRolu.values[kayit.rol],
      aktifMi: kayit.aktifMi,
      adresMetni: kayit.adresMetni,
    );
  }

  Future<MisafirBilgisiVarligi> misafirKaydet(
    MisafirBilgisiVarligi misafir,
  ) async {
    await into(misafirKayitlari).insertOnConflictUpdate(
      MisafirKayitlariCompanion(
        adSoyad: Value(misafir.adSoyad),
        telefon: Value(misafir.telefon),
        eposta: Value(misafir.eposta),
        adres: Value(misafir.adres),
      ),
    );
    return misafir;
  }

  String secenekleriJsonYap(List<Map<String, Object?>> secenekler) {
    return jsonEncode(secenekler);
  }

  List<Map<String, Object?>> secenekleriCoz(String json) {
    final List<dynamic> ham = jsonDecode(json) as List<dynamic>;
    return ham.map((item) => Map<String, Object?>.from(item as Map)).toList();
  }

  Future<void> _indeksleriOlustur() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_urun_kategori '
      'ON urun_kayitlari (kategori_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sepet_kalemleri_sepet '
      'ON sepet_kalemleri (sepet_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_siparis_kalemleri_siparis '
      'ON siparis_kalemleri (siparis_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_masa_kayitlari_bolum '
      'ON masa_kayitlari (bolum_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_recete_kalem_kayitlari_urun '
      'ON recete_kalem_kayitlari (urun_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_recete_kalem_kayitlari_hammadde '
      'ON recete_kalem_kayitlari (hammadde_id)',
    );
  }

  Future<void> _eskiJsonVerisiniYeniTablolaraTasi() async {
    await _eskiYaziciVerisiniTasi();
    await _eskiPersonelVerisiniTasi();
    await _eskiSalonVerisiniTasi();
    await _eskiStokVerisiniTasi();
  }

  Future<void> _eskiYaziciVerisiniTasi() async {
    final String? jsonVeri = await ayarOku('yonetim_yazicilar_v1');
    if (jsonVeri == null || jsonVeri.isEmpty) {
      return;
    }
    final dynamic ham = _guvenliJsonCoz(jsonVeri);
    if (ham is! List) {
      return;
    }
    for (final dynamic item in ham) {
      final Map<String, Object?> kayit = Map<String, Object?>.from(item as Map);
      final String yaziciId = await numerikKimlikCozumle(
        tabloAdi: 'yazici_kayitlari',
        adayKimlik: (kayit['id'] as String?) ?? '',
      );
      await into(yaziciKayitlari).insertOnConflictUpdate(
        YaziciKayitlariCompanion(
          id: Value(yaziciId),
          ad: Value(kayit['ad'] as String),
          rolEtiketi: Value(kayit['rolEtiketi'] as String),
          baglantiNoktasi: Value(kayit['baglantiNoktasi'] as String),
          aciklama: Value(kayit['aciklama'] as String),
          durum: Value((kayit['durum'] as num).toInt()),
        ),
      );
    }
  }

  Future<void> _eskiPersonelVerisiniTasi() async {
    final String? jsonVeri = await ayarOku('yonetim_personel_v1');
    if (jsonVeri == null || jsonVeri.isEmpty) {
      return;
    }
    final dynamic ham = _guvenliJsonCoz(jsonVeri);
    if (ham is! List) {
      return;
    }
    for (final dynamic item in ham) {
      final Map<String, Object?> kayit = Map<String, Object?>.from(item as Map);
      final String kimlik = await numerikKimlikCozumle(
        tabloAdi: 'personel_kayitlari',
        kimlikKolonu: 'kimlik',
        adayKimlik: (kayit['kimlik'] as String?) ?? '',
      );
      await into(personelKayitlari).insertOnConflictUpdate(
        PersonelKayitlariCompanion(
          kimlik: Value(kimlik),
          adSoyad: Value(kayit['adSoyad'] as String),
          rolEtiketi: Value(kayit['rolEtiketi'] as String),
          bolge: Value(kayit['bolge'] as String),
          aciklama: Value(kayit['aciklama'] as String),
          durum: Value((kayit['durum'] as num).toInt()),
        ),
      );
    }
  }

  Future<void> _eskiSalonVerisiniTasi() async {
    final String? jsonVeri = await ayarOku('yonetim_salon_plani_v1');
    if (jsonVeri == null || jsonVeri.isEmpty) {
      return;
    }
    final dynamic ham = _guvenliJsonCoz(jsonVeri);
    if (ham is! List) {
      return;
    }
    for (final dynamic item in ham) {
      final Map<String, Object?> bolum = Map<String, Object?>.from(item as Map);
      final String eskiBolumId = (bolum['id'] as String?) ?? '';
      final String yeniBolumId = await numerikKimlikCozumle(
        tabloAdi: 'salon_bolum_kayitlari',
        adayKimlik: eskiBolumId,
      );
      await into(salonBolumKayitlari).insertOnConflictUpdate(
        SalonBolumKayitlariCompanion(
          id: Value(yeniBolumId),
          ad: Value(bolum['ad'] as String),
          aciklama: Value(bolum['aciklama'] as String),
        ),
      );
      final List<dynamic> masalar =
          (bolum['masalar'] as List<dynamic>? ?? <dynamic>[]);
      for (final dynamic masaHam in masalar) {
        final Map<String, Object?> masa = Map<String, Object?>.from(
          masaHam as Map,
        );
        final String masaId = await numerikKimlikCozumle(
          tabloAdi: 'masa_kayitlari',
          adayKimlik: (masa['id'] as String?) ?? '',
        );
        await into(masaKayitlari).insertOnConflictUpdate(
          MasaKayitlariCompanion(
            id: Value(masaId),
            bolumId: Value(yeniBolumId),
            ad: Value(masa['ad'] as String),
            kapasite: Value((masa['kapasite'] as num).toInt()),
          ),
        );
      }
    }
  }

  Future<void> _eskiStokVerisiniTasi() async {
    final String? jsonVeri = await ayarOku('stok_veri_v1');
    if (jsonVeri == null || jsonVeri.isEmpty) {
      return;
    }
    final dynamic ham = _guvenliJsonCoz(jsonVeri);
    if (ham is! Map) {
      return;
    }
    final Map<String, Object?> veri = Map<String, Object?>.from(ham);
    final List<dynamic> hammaddelerHam =
        (veri['hammaddeler'] as List<dynamic>? ?? <dynamic>[]);
    final Map<String, dynamic> recetelerHam = Map<String, dynamic>.from(
      veri['receteler'] as Map? ?? <String, dynamic>{},
    );

    final Map<String, String> hammaddeIdHaritasi = <String, String>{};
    for (final dynamic hammaddeHam in hammaddelerHam) {
      final Map<String, Object?> hammadde = Map<String, Object?>.from(
        hammaddeHam as Map,
      );
      final String eskiHammaddeId = (hammadde['id'] as String?) ?? '';
      final String yeniHammaddeId = await numerikKimlikCozumle(
        tabloAdi: 'hammadde_kayitlari',
        adayKimlik: eskiHammaddeId,
      );
      hammaddeIdHaritasi[eskiHammaddeId] = yeniHammaddeId;
      await into(hammaddeKayitlari).insertOnConflictUpdate(
        HammaddeKayitlariCompanion(
          id: Value(yeniHammaddeId),
          ad: Value(hammadde['ad'] as String),
          birim: Value(hammadde['birim'] as String),
          mevcutMiktar: Value((hammadde['mevcutMiktar'] as num).toDouble()),
          kritikEsik: Value((hammadde['kritikEsik'] as num).toDouble()),
          birimMaliyet: Value((hammadde['birimMaliyet'] as num).toDouble()),
        ),
      );
    }

    for (final MapEntry<String, dynamic> giris in recetelerHam.entries) {
      final String urunId =
          (await (select(
            urunKayitlari,
          )..where((tbl) => tbl.id.equals(giris.key))).getSingleOrNull())?.id ??
          giris.key;
      final bool urunVarMi =
          await (select(
            urunKayitlari,
          )..where((tbl) => tbl.id.equals(urunId))).getSingleOrNull() !=
          null;
      if (!urunVarMi) {
        continue;
      }
      final List<dynamic> receteHam =
          (giris.value as List<dynamic>? ?? <dynamic>[]);
      for (final dynamic receteKalemiHam in receteHam) {
        final Map<String, Object?> receteKalemi = Map<String, Object?>.from(
          receteKalemiHam as Map,
        );
        final String eskiHammaddeId =
            (receteKalemi['hammaddeId'] as String?) ?? '';
        final String? hammaddeId =
            hammaddeIdHaritasi[eskiHammaddeId] ??
            (await (select(hammaddeKayitlari)
                      ..where((tbl) => tbl.id.equals(eskiHammaddeId)))
                    .getSingleOrNull())
                ?.id;
        if (hammaddeId == null) {
          continue;
        }
        await into(receteKalemKayitlari).insertOnConflictUpdate(
          ReceteKalemKayitlariCompanion(
            urunId: Value(urunId),
            hammaddeId: Value(hammaddeId),
            miktar: Value((receteKalemi['miktar'] as num).toDouble()),
          ),
        );
      }
    }
  }

  Future<void> _tumKimlikleriNumeriklestir(Migrator migrator) async {
    final List<KullaniciKayitlariData> kullanicilar = await select(
      kullaniciKayitlari,
    ).get();
    final List<MisafirKayitlariData> misafirler = await select(
      misafirKayitlari,
    ).get();
    final List<KategoriKayitlariData> kategoriler = await select(
      kategoriKayitlari,
    ).get();
    final List<UrunKayitlariData> urunler = await select(urunKayitlari).get();
    final List<SepetKayitlariData> sepetler = await select(
      sepetKayitlari,
    ).get();
    final List<SepetKalemleriData> sepetKalemleriKayitlari = await select(
      sepetKalemleri,
    ).get();
    final List<SiparisKayitlariData> siparisler = await select(
      siparisKayitlari,
    ).get();
    final List<SiparisKalemleriData> siparisKalemleriKayitlari = await select(
      siparisKalemleri,
    ).get();
    final List<UygulamaAyarlarData> ayarlar = await select(
      uygulamaAyarlar,
    ).get();
    final List<YaziciKayitlariData> yazicilar = await select(
      yaziciKayitlari,
    ).get();
    final List<PersonelKayitlariData> personeller = await select(
      personelKayitlari,
    ).get();
    final List<SalonBolumKayitlariData> salonBolumleri = await select(
      salonBolumKayitlari,
    ).get();
    final List<MasaKayitlariData> masalar = await select(masaKayitlari).get();
    final List<HammaddeKayitlariData> hammaddeler = await select(
      hammaddeKayitlari,
    ).get();
    final List<ReceteKalemKayitlariData> receteler = await select(
      receteKalemKayitlari,
    ).get();

    final Map<String, String> kullaniciIdHaritasi = _kimlikHaritasiOlustur(
      kullanicilar.map((kayit) => kayit.id),
    );
    final Map<String, String> kategoriIdHaritasi = _kimlikHaritasiOlustur(
      kategoriler.map((kayit) => kayit.id),
    );
    final Map<String, String> urunIdHaritasi = _kimlikHaritasiOlustur(
      urunler.map((kayit) => kayit.id),
    );
    final Map<String, String> sepetIdHaritasi = _kimlikHaritasiOlustur(
      sepetler.map((kayit) => kayit.id),
    );
    final Map<String, String> sepetKalemIdHaritasi = _kimlikHaritasiOlustur(
      sepetKalemleriKayitlari.map((kayit) => kayit.id),
    );
    final Map<String, String> siparisIdHaritasi = _kimlikHaritasiOlustur(
      siparisler.map((kayit) => kayit.id),
    );
    final Map<String, String> siparisKalemIdHaritasi = _kimlikHaritasiOlustur(
      siparisKalemleriKayitlari.map((kayit) => kayit.id),
    );
    final Map<String, String> yaziciIdHaritasi = _kimlikHaritasiOlustur(
      yazicilar.map((kayit) => kayit.id),
    );
    final Map<String, String> personelIdHaritasi = _kimlikHaritasiOlustur(
      personeller.map((kayit) => kayit.kimlik),
    );
    final Map<String, String> bolumIdHaritasi = _kimlikHaritasiOlustur(
      salonBolumleri.map((kayit) => kayit.id),
    );
    final Map<String, String> masaIdHaritasi = _kimlikHaritasiOlustur(
      masalar.map((kayit) => kayit.id),
    );
    final Map<String, String> hammaddeIdHaritasi = _kimlikHaritasiOlustur(
      hammaddeler.map((kayit) => kayit.id),
    );

    await customStatement('PRAGMA foreign_keys = OFF');
    await _tumTablolariSilYenidenOlustur(migrator);

    await batch((batch) {
      batch.insertAll(
        kullaniciKayitlari,
        kullanicilar
            .map(
              (kayit) => KullaniciKayitlariCompanion.insert(
                id: _kimlikHaritasiUygula(kullaniciIdHaritasi, kayit.id),
                adSoyad: kayit.adSoyad,
                telefon: kayit.telefon,
                eposta: Value(kayit.eposta),
                rol: kayit.rol,
                aktifMi: kayit.aktifMi,
                adresMetni: Value(kayit.adresMetni),
              ),
            )
            .toList(),
      );
      batch.insertAll(
        misafirKayitlari,
        misafirler
            .map(
              (kayit) => MisafirKayitlariCompanion.insert(
                adSoyad: kayit.adSoyad,
                telefon: kayit.telefon,
                eposta: Value(kayit.eposta),
                adres: Value(kayit.adres),
              ),
            )
            .toList(),
      );
      batch.insertAll(
        uygulamaAyarlar,
        ayarlar
            .map(
              (kayit) => UygulamaAyarlarCompanion.insert(
                anahtar: kayit.anahtar,
                deger: kayit.deger,
              ),
            )
            .toList(),
      );
      batch.insertAll(
        kategoriKayitlari,
        kategoriler
            .map(
              (kayit) => KategoriKayitlariCompanion.insert(
                id: _kimlikHaritasiUygula(kategoriIdHaritasi, kayit.id),
                ad: kayit.ad,
                sira: kayit.sira,
                acikMi: kayit.acikMi,
              ),
            )
            .toList(),
      );
      batch.insertAll(
        urunKayitlari,
        urunler
            .map(
              (kayit) => UrunKayitlariCompanion.insert(
                id: _kimlikHaritasiUygula(urunIdHaritasi, kayit.id),
                kategoriId: _kimlikHaritasiUygula(
                  kategoriIdHaritasi,
                  kayit.kategoriId,
                ),
                ad: kayit.ad,
                aciklama: kayit.aciklama,
                fiyat: kayit.fiyat,
                gorselUrl: Value(kayit.gorselUrl),
                stoktaMi: kayit.stoktaMi,
                oneCikanMi: kayit.oneCikanMi,
                seceneklerJson: kayit.seceneklerJson,
              ),
            )
            .toList(),
      );
      batch.insertAll(
        sepetKayitlari,
        sepetler
            .map(
              (kayit) => SepetKayitlariCompanion.insert(
                id: _kimlikHaritasiUygula(sepetIdHaritasi, kayit.id),
                kuponKodu: Value(kayit.kuponKodu),
              ),
            )
            .toList(),
      );
      batch.insertAll(
        siparisKayitlari,
        siparisler
            .map(
              (kayit) => SiparisKayitlariCompanion.insert(
                id: _kimlikHaritasiUygula(siparisIdHaritasi, kayit.id),
                siparisNo: kayit.siparisNo,
                teslimatTipi: kayit.teslimatTipi,
                durum: kayit.durum,
                olusturmaTarihi: kayit.olusturmaTarihi,
                adresMetni: Value(kayit.adresMetni),
                teslimatNotu: Value(kayit.teslimatNotu),
                kuryeAdi: Value(kayit.kuryeAdi),
                paketTeslimatDurumu: Value(kayit.paketTeslimatDurumu),
                masaNo: Value(kayit.masaNo),
                bolumAdi: Value(kayit.bolumAdi),
                kaynak: Value(kayit.kaynak),
                sahipMisafir: kayit.sahipMisafir,
                sahipAdSoyad: kayit.sahipAdSoyad,
                sahipTelefon: kayit.sahipTelefon,
                sahipEposta: Value(kayit.sahipEposta),
                sahipAdres: Value(kayit.sahipAdres),
              ),
            )
            .toList(),
      );
      batch.insertAll(
        salonBolumKayitlari,
        salonBolumleri
            .map(
              (kayit) => SalonBolumKayitlariCompanion.insert(
                id: _kimlikHaritasiUygula(bolumIdHaritasi, kayit.id),
                ad: kayit.ad,
                aciklama: kayit.aciklama,
              ),
            )
            .toList(),
      );
      batch.insertAll(
        hammaddeKayitlari,
        hammaddeler
            .map(
              (kayit) => HammaddeKayitlariCompanion.insert(
                id: _kimlikHaritasiUygula(hammaddeIdHaritasi, kayit.id),
                ad: kayit.ad,
                birim: kayit.birim,
                mevcutMiktar: kayit.mevcutMiktar,
                kritikEsik: kayit.kritikEsik,
                birimMaliyet: kayit.birimMaliyet,
              ),
            )
            .toList(),
      );
      batch.insertAll(
        yaziciKayitlari,
        yazicilar
            .map(
              (kayit) => YaziciKayitlariCompanion.insert(
                id: _kimlikHaritasiUygula(yaziciIdHaritasi, kayit.id),
                ad: kayit.ad,
                rolEtiketi: kayit.rolEtiketi,
                baglantiNoktasi: kayit.baglantiNoktasi,
                aciklama: kayit.aciklama,
                durum: kayit.durum,
              ),
            )
            .toList(),
      );
      batch.insertAll(
        personelKayitlari,
        personeller
            .map(
              (kayit) => PersonelKayitlariCompanion.insert(
                kimlik: _kimlikHaritasiUygula(personelIdHaritasi, kayit.kimlik),
                adSoyad: kayit.adSoyad,
                rolEtiketi: kayit.rolEtiketi,
                bolge: kayit.bolge,
                aciklama: kayit.aciklama,
                durum: kayit.durum,
              ),
            )
            .toList(),
      );

      final List<MasaKayitlariCompanion> masaCompanionlari =
          <MasaKayitlariCompanion>[];
      for (final MasaKayitlariData masa in masalar) {
        final String? bolumId = bolumIdHaritasi[masa.bolumId];
        if (bolumId == null) {
          continue;
        }
        masaCompanionlari.add(
          MasaKayitlariCompanion.insert(
            id: _kimlikHaritasiUygula(masaIdHaritasi, masa.id),
            bolumId: bolumId,
            ad: masa.ad,
            kapasite: masa.kapasite,
          ),
        );
      }
      batch.insertAll(masaKayitlari, masaCompanionlari);

      final List<SepetKalemleriCompanion> sepetKalemiCompanionlari =
          <SepetKalemleriCompanion>[];
      for (final SepetKalemleriData kalem in sepetKalemleriKayitlari) {
        final String? sepetId = sepetIdHaritasi[kalem.sepetId];
        final String? urunId = urunIdHaritasi[kalem.urunId];
        if (sepetId == null || urunId == null) {
          continue;
        }
        sepetKalemiCompanionlari.add(
          SepetKalemleriCompanion.insert(
            id: _kimlikHaritasiUygula(sepetKalemIdHaritasi, kalem.id),
            sepetId: sepetId,
            urunId: urunId,
            birimFiyat: kalem.birimFiyat,
            adet: kalem.adet,
            secenekAdi: Value(kalem.secenekAdi),
            notMetni: Value(kalem.notMetni),
          ),
        );
      }
      batch.insertAll(sepetKalemleri, sepetKalemiCompanionlari);

      final List<SiparisKalemleriCompanion> siparisKalemiCompanionlari =
          <SiparisKalemleriCompanion>[];
      for (final SiparisKalemleriData kalem in siparisKalemleriKayitlari) {
        final String? siparisId = siparisIdHaritasi[kalem.siparisId];
        if (siparisId == null) {
          continue;
        }
        final String urunId = urunIdHaritasi[kalem.urunId] ?? kalem.urunId;
        siparisKalemiCompanionlari.add(
          SiparisKalemleriCompanion.insert(
            id: _kimlikHaritasiUygula(siparisKalemIdHaritasi, kalem.id),
            siparisId: siparisId,
            urunId: urunId,
            urunAdi: kalem.urunAdi,
            birimFiyat: kalem.birimFiyat,
            adet: kalem.adet,
            secenekAdi: Value(kalem.secenekAdi),
            notMetni: Value(kalem.notMetni),
          ),
        );
      }
      batch.insertAll(siparisKalemleri, siparisKalemiCompanionlari);

      final List<ReceteKalemKayitlariCompanion> receteCompanionlari =
          <ReceteKalemKayitlariCompanion>[];
      for (final ReceteKalemKayitlariData kalem in receteler) {
        final String? urunId = urunIdHaritasi[kalem.urunId];
        final String? hammaddeId = hammaddeIdHaritasi[kalem.hammaddeId];
        if (urunId == null || hammaddeId == null) {
          continue;
        }
        receteCompanionlari.add(
          ReceteKalemKayitlariCompanion.insert(
            urunId: urunId,
            hammaddeId: hammaddeId,
            miktar: kalem.miktar,
          ),
        );
      }
      batch.insertAll(receteKalemKayitlari, receteCompanionlari);
    });

    await customStatement('PRAGMA foreign_keys = ON');
  }

  Future<void> _tumTablolariSilYenidenOlustur(Migrator migrator) async {
    await migrator.deleteTable('recete_kalem_kayitlari');
    await migrator.deleteTable('masa_kayitlari');
    await migrator.deleteTable('siparis_kalemleri');
    await migrator.deleteTable('sepet_kalemleri');
    await migrator.deleteTable('hammadde_kayitlari');
    await migrator.deleteTable('salon_bolum_kayitlari');
    await migrator.deleteTable('siparis_kayitlari');
    await migrator.deleteTable('sepet_kayitlari');
    await migrator.deleteTable('urun_kayitlari');
    await migrator.deleteTable('kategori_kayitlari');
    await migrator.deleteTable('personel_kayitlari');
    await migrator.deleteTable('yazici_kayitlari');
    await migrator.deleteTable('uygulama_ayarlar');
    await migrator.deleteTable('misafir_kayitlari');
    await migrator.deleteTable('kullanici_kayitlari');
    await migrator.createAll();
    await _indeksleriOlustur();
  }

  Map<String, String> _kimlikHaritasiOlustur(Iterable<String> kimlikler) {
    final List<String> benzersizKimlikler = kimlikler.toSet().toList()
      ..sort((String sol, String sag) {
        final int? solSayi = int.tryParse(sol);
        final int? sagSayi = int.tryParse(sag);
        if (solSayi != null && sagSayi != null) {
          return solSayi.compareTo(sagSayi);
        }
        if (solSayi != null) {
          return -1;
        }
        if (sagSayi != null) {
          return 1;
        }
        return sol.compareTo(sag);
      });
    return <String, String>{
      for (int i = 0; i < benzersizKimlikler.length; i++)
        benzersizKimlikler[i]: '${i + 1}',
    };
  }

  String _kimlikHaritasiUygula(Map<String, String> harita, String kimlik) {
    return harita[kimlik] ?? kimlik;
  }

  dynamic _guvenliJsonCoz(String jsonVeri) {
    try {
      return jsonDecode(jsonVeri);
    } catch (_) {
      return null;
    }
  }
}

QueryExecutor _baglanti() => veritabaniBaglantisiOlustur();
