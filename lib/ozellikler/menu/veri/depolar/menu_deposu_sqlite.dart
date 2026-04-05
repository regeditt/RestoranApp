import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_secenegi_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ortak/veri/seed_verisi_saglayici.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class MenuDeposuSqlite implements MenuDeposu {
  MenuDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;
  final SeedVerisiSaglayici _seedSaglayici = const SeedVerisiSaglayici();
  bool _seedKontrolEdildi = false;

  @override
  Future<List<KategoriVarligi>> kategorileriGetir() async {
    await _seedEminOl();
    final kayitlar = await _veritabani
        .select(_veritabani.kategoriKayitlari)
        .get();
    return kayitlar
        .map(
          (kayit) => KategoriVarligi(
            id: kayit.id,
            ad: kayit.ad,
            sira: kayit.sira,
            acikMi: kayit.acikMi,
          ),
        )
        .toList();
  }

  @override
  Future<void> kategoriEkle(KategoriVarligi kategori) async {
    final String kategoriId = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'kategori_kayitlari',
      adayKimlik: kategori.id,
    );
    await _veritabani
        .into(_veritabani.kategoriKayitlari)
        .insertOnConflictUpdate(
          KategoriKayitlariCompanion(
            id: Value(kategoriId),
            ad: Value(kategori.ad),
            sira: Value(kategori.sira),
            acikMi: Value(kategori.acikMi),
          ),
        );
  }

  @override
  Future<void> kategoriGuncelle(KategoriVarligi kategori) async {
    await kategoriEkle(kategori);
  }

  @override
  Future<void> kategoriSil(String kategoriId) async {
    await (_veritabani.delete(
      _veritabani.kategoriKayitlari,
    )..where((tbl) => tbl.id.equals(kategoriId))).go();
  }

  @override
  Future<List<UrunVarligi>> urunleriGetir() async {
    await _seedEminOl();
    final kayitlar = await _veritabani.select(_veritabani.urunKayitlari).get();
    return kayitlar.map(_urunCoz).toList();
  }

  @override
  Future<void> urunEkle(UrunVarligi urun) async {
    final String urunId = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'urun_kayitlari',
      adayKimlik: urun.id,
    );
    await _veritabani
        .into(_veritabani.urunKayitlari)
        .insertOnConflictUpdate(
          UrunKayitlariCompanion(
            id: Value(urunId),
            kategoriId: Value(urun.kategoriId),
            ad: Value(urun.ad),
            aciklama: Value(urun.aciklama),
            fiyat: Value(urun.fiyat),
            gorselUrl: Value(urun.gorselUrl),
            stoktaMi: Value(urun.stoktaMi),
            oneCikanMi: Value(urun.oneCikanMi),
            seceneklerJson: Value(_secenekleriJson(urun.secenekler)),
          ),
        );
  }

  @override
  Future<void> urunGuncelle(UrunVarligi urun) async {
    await urunEkle(urun);
  }

  @override
  Future<void> urunSil(String urunId) async {
    await (_veritabani.delete(
      _veritabani.urunKayitlari,
    )..where((tbl) => tbl.id.equals(urunId))).go();
  }

  @override
  Future<List<UrunVarligi>> kategoriyeGoreUrunleriGetir(
    String kategoriId,
  ) async {
    await _seedEminOl();
    final kayitlar = await (_veritabani.select(
      _veritabani.urunKayitlari,
    )..where((tbl) => tbl.kategoriId.equals(kategoriId))).get();
    return kayitlar.map(_urunCoz).toList();
  }

  @override
  Future<UrunVarligi?> urunGetir(String urunId) async {
    await _seedEminOl();
    final kayit = await (_veritabani.select(
      _veritabani.urunKayitlari,
    )..where((tbl) => tbl.id.equals(urunId))).getSingleOrNull();
    return kayit == null ? null : _urunCoz(kayit);
  }

  String _secenekleriJson(List<UrunSecenegiVarligi> secenekler) {
    return _veritabani.secenekleriJsonYap(
      secenekler
          .map(
            (secenek) => <String, Object?>{
              'id': secenek.id,
              'ad': secenek.ad,
              'fiyatFarki': secenek.fiyatFarki,
              'varsayilanMi': secenek.varsayilanMi,
            },
          )
          .toList(),
    );
  }

  List<UrunSecenegiVarligi> _secenekleriCoz(String json) {
    return _veritabani
        .secenekleriCoz(json)
        .map(
          (item) => UrunSecenegiVarligi(
            id: item['id'] as String,
            ad: item['ad'] as String,
            fiyatFarki: (item['fiyatFarki'] as num).toDouble(),
            varsayilanMi: item['varsayilanMi'] as bool,
          ),
        )
        .toList();
  }

  UrunVarligi _urunCoz(UrunKayitlariData kayit) {
    return UrunVarligi(
      id: kayit.id,
      kategoriId: kayit.kategoriId,
      ad: kayit.ad,
      aciklama: kayit.aciklama,
      fiyat: kayit.fiyat,
      gorselUrl: kayit.gorselUrl,
      stoktaMi: kayit.stoktaMi,
      oneCikanMi: kayit.oneCikanMi,
      secenekler: _secenekleriCoz(kayit.seceneklerJson),
    );
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final String? seedDurumu = await _veritabani.ayarOku('menu_seeded');
    if (seedDurumu == 'true') {
      _seedKontrolEdildi = true;
      return;
    }
    final List<KategoriVarligi> kategoriler = await _seedSaglayici
        .kategorileriGetir();
    final List<UrunVarligi> urunler = await _seedSaglayici.urunleriGetir();
    final Map<String, String> kategoriIdHaritasi = <String, String>{};
    await _veritabani.transaction(() async {
      for (final kategori in kategoriler) {
        final String kategoriId = await _veritabani.sonrakiNumerikKimlikGetir(
          tabloAdi: 'kategori_kayitlari',
        );
        kategoriIdHaritasi[kategori.id] = kategoriId;
        await _veritabani
            .into(_veritabani.kategoriKayitlari)
            .insert(
              KategoriKayitlariCompanion(
                id: Value(kategoriId),
                ad: Value(kategori.ad),
                sira: Value(kategori.sira),
                acikMi: Value(kategori.acikMi),
              ),
            );
      }
      for (final urun in urunler) {
        final String? kategoriId = kategoriIdHaritasi[urun.kategoriId];
        if (kategoriId == null) {
          continue;
        }
        final String urunId = await _veritabani.sonrakiNumerikKimlikGetir(
          tabloAdi: 'urun_kayitlari',
        );
        await _veritabani
            .into(_veritabani.urunKayitlari)
            .insert(
              UrunKayitlariCompanion(
                id: Value(urunId),
                kategoriId: Value(kategoriId),
                ad: Value(urun.ad),
                aciklama: Value(urun.aciklama),
                fiyat: Value(urun.fiyat),
                gorselUrl: Value(urun.gorselUrl),
                stoktaMi: Value(urun.stoktaMi),
                oneCikanMi: Value(urun.oneCikanMi),
                seceneklerJson: Value(_secenekleriJson(urun.secenekler)),
              ),
            );
      }
    });
    await _veritabani.ayarYaz('menu_seeded', 'true');
    _seedKontrolEdildi = true;
  }
}
