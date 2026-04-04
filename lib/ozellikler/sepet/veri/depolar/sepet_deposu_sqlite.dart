import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class SepetDeposuSqlite implements SepetDeposu {
  SepetDeposuSqlite(this._veritabani, this._menuDeposu);

  final UygulamaVeritabani _veritabani;
  final MenuDeposu _menuDeposu;

  static const String _varsayilanSepetId = 'sep_001';

  @override
  Future<SepetVarligi> sepetiGetir() async {
    final sepet = await _sepetKaydiniGetir();
    final kalemler = await _kalemleriGetir(sepet.id);
    return SepetVarligi(id: sepet.id, kalemler: kalemler, kuponKodu: sepet.kuponKodu);
  }

  @override
  Future<SepetVarligi> urunEkle({
    required String urunId,
    required int adet,
    String? secenekId,
    String? notMetni,
  }) async {
    final sepet = await _sepetKaydiniGetir();
    final UrunVarligi? urun = await _menuDeposu.urunGetir(urunId);
    if (urun == null) {
      return sepetiGetir();
    }
    final String kalemId = 'kal_${DateTime.now().microsecondsSinceEpoch}';
    await _veritabani.into(_veritabani.sepetKalemleri).insert(
      SepetKalemleriCompanion(
        id: Value(kalemId),
        sepetId: Value(sepet.id),
        urunId: Value(urun.id),
        birimFiyat: Value(urun.fiyat),
        adet: Value(adet),
        secenekAdi: Value(
          secenekId == null
              ? urun.varsayilanSecenek?.ad
              : urun.secenekler
                  .firstWhere((secenek) => secenek.id == secenekId)
                  .ad,
        ),
        notMetni: Value(notMetni),
      ),
    );
    return sepetiGetir();
  }

  @override
  Future<SepetVarligi> kalemGuncelle({
    required String kalemId,
    required int adet,
  }) async {
    await (_veritabani.update(_veritabani.sepetKalemleri)
          ..where((tbl) => tbl.id.equals(kalemId)))
        .write(SepetKalemleriCompanion(adet: Value(adet)));
    return sepetiGetir();
  }

  @override
  Future<SepetVarligi> kalemSil(String kalemId) async {
    await (_veritabani.delete(_veritabani.sepetKalemleri)
          ..where((tbl) => tbl.id.equals(kalemId)))
        .go();
    return sepetiGetir();
  }

  @override
  Future<void> sepetiTemizle() async {
    final sepet = await _sepetKaydiniGetir();
    await (_veritabani.delete(_veritabani.sepetKalemleri)
          ..where((tbl) => tbl.sepetId.equals(sepet.id)))
        .go();
  }

  Future<SepetKayitlariData> _sepetKaydiniGetir() async {
    final mevcut = await (_veritabani.select(_veritabani.sepetKayitlari)
          ..where((tbl) => tbl.id.equals(_varsayilanSepetId)))
        .getSingleOrNull();
    if (mevcut != null) {
      return mevcut;
    }
    await _veritabani.into(_veritabani.sepetKayitlari).insert(
      SepetKayitlariCompanion(
        id: Value(_varsayilanSepetId),
        kuponKodu: const Value.absent(),
      ),
    );
    return (await (_veritabani.select(_veritabani.sepetKayitlari)
          ..where((tbl) => tbl.id.equals(_varsayilanSepetId)))
        .getSingle());
  }

  Future<List<SepetKalemiVarligi>> _kalemleriGetir(String sepetId) async {
    final kalemKayitlari = await (_veritabani.select(_veritabani.sepetKalemleri)
          ..where((tbl) => tbl.sepetId.equals(sepetId)))
        .get();
    final List<UrunVarligi> urunler = await _menuDeposu.urunleriGetir();
    final Map<String, UrunVarligi> urunHaritasi = <String, UrunVarligi>{
      for (final UrunVarligi urun in urunler) urun.id: urun,
    };
    final List<SepetKalemiVarligi> kalemler = <SepetKalemiVarligi>[];
    for (final kalem in kalemKayitlari) {
      final UrunVarligi? urun = urunHaritasi[kalem.urunId];
      if (urun == null) {
        continue;
      }
      kalemler.add(
        SepetKalemiVarligi(
          id: kalem.id,
          urun: urun,
          birimFiyat: kalem.birimFiyat,
          adet: kalem.adet,
          secenekAdi: kalem.secenekAdi,
          notMetni: kalem.notMetni,
        ),
      );
    }
    return kalemler;
  }
}
