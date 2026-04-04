import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_baslatma.dart';

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
  TextColumn get kategoriId => text()();
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
  TextColumn get sepetId => text()();
  TextColumn get urunId => text()();
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
  TextColumn get siparisId => text()();
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
  ],
)
class UygulamaVeritabani extends _$UygulamaVeritabani
    implements VeriKaynagiBaslatma {
  UygulamaVeritabani() : super(_baglanti());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await _indeksleriOlustur();
        },
        onUpgrade: (migrator, from, to) async {
          await migrator.createAll();
          await _indeksleriOlustur();
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
      UygulamaAyarlarCompanion(
        anahtar: Value(anahtar),
        deger: Value(deger),
      ),
    );
  }

  Future<String?> ayarOku(String anahtar) async {
    final kayit = await (select(uygulamaAyarlar)
          ..where((tbl) => tbl.anahtar.equals(anahtar)))
        .getSingleOrNull();
    return kayit?.deger;
  }

  Future<KullaniciVarligi?> aktifKullaniciGetir() async {
    final kayit = await (select(kullaniciKayitlari)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.aktifMi)]))
        .getSingleOrNull();
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
    return ham
        .map((item) => Map<String, Object?>.from(item as Map))
        .toList();
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
  }
}

LazyDatabase _baglanti() {
  return LazyDatabase(() async {
    final Directory dizin = await getApplicationDocumentsDirectory();
    final File dosya = File('${dizin.path}/restoran_app.sqlite');
    return NativeDatabase(dosya);
  });
}
