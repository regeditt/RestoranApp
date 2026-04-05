import 'package:drift/drift.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class VeriAktarimServisi {
  VeriAktarimServisi(this._veritabani);

  final UygulamaVeritabani _veritabani;

  Future<Map<String, Object?>> menuDisaAktar() async {
    final kategoriler = await _veritabani
        .select(_veritabani.kategoriKayitlari)
        .get();
    final urunler = await _veritabani.select(_veritabani.urunKayitlari).get();

    return <String, Object?>{
      'surum': 1,
      'olusturmaTarihi': DateTime.now().toIso8601String(),
      'kategoriler': kategoriler
          .map(
            (k) => <String, Object?>{
              'id': k.id,
              'ad': k.ad,
              'sira': k.sira,
              'acikMi': k.acikMi,
            },
          )
          .toList(),
      'urunler': urunler
          .map(
            (u) => <String, Object?>{
              'id': u.id,
              'kategoriId': u.kategoriId,
              'ad': u.ad,
              'aciklama': u.aciklama,
              'fiyat': u.fiyat,
              'gorselUrl': u.gorselUrl,
              'stoktaMi': u.stoktaMi,
              'oneCikanMi': u.oneCikanMi,
              'seceneklerJson': u.seceneklerJson,
            },
          )
          .toList(),
    };
  }

  Future<void> menuIceriAktar(
    Map<String, Object?> veri, {
    bool temizle = false,
  }) async {
    final int surum = (veri['surum'] as num?)?.toInt() ?? 1;
    if (surum != 1) {
      throw StateError('Desteklenmeyen menu veri surumu: $surum');
    }
    final List<dynamic> kategoriHam =
        (veri['kategoriler'] as List<dynamic>? ?? <dynamic>[]);
    final List<dynamic> urunHam =
        (veri['urunler'] as List<dynamic>? ?? <dynamic>[]);

    await _veritabani.transaction(() async {
      if (temizle) {
        await _veritabani.delete(_veritabani.urunKayitlari).go();
        await _veritabani.delete(_veritabani.kategoriKayitlari).go();
      }

      final Map<String, String> kategoriIdHaritasi = <String, String>{};
      for (final ham in kategoriHam) {
        final Map<String, Object?> k = Map<String, Object?>.from(ham as Map);
        final String kaynakId = (k['id'] as String?) ?? '';
        final String kategoriId = await _veritabani.numerikKimlikCozumle(
          tabloAdi: 'kategori_kayitlari',
          adayKimlik: kaynakId,
        );
        kategoriIdHaritasi[kaynakId] = kategoriId;
        await _veritabani
            .into(_veritabani.kategoriKayitlari)
            .insertOnConflictUpdate(
              KategoriKayitlariCompanion(
                id: Value(kategoriId),
                ad: Value(k['ad'] as String),
                sira: Value((k['sira'] as num).toInt()),
                acikMi: Value(k['acikMi'] as bool),
              ),
            );
      }

      for (final ham in urunHam) {
        final Map<String, Object?> u = Map<String, Object?>.from(ham as Map);
        final String urunId = await _veritabani.numerikKimlikCozumle(
          tabloAdi: 'urun_kayitlari',
          adayKimlik: (u['id'] as String?) ?? '',
        );
        final String kaynakKategoriId = (u['kategoriId'] as String?) ?? '';
        final String? kategoriId =
            kategoriIdHaritasi[kaynakKategoriId] ??
            (await (_veritabani.select(_veritabani.kategoriKayitlari)
                      ..where((tbl) => tbl.id.equals(kaynakKategoriId)))
                    .getSingleOrNull())
                ?.id;
        if (kategoriId == null) {
          continue;
        }
        await _veritabani
            .into(_veritabani.urunKayitlari)
            .insertOnConflictUpdate(
              UrunKayitlariCompanion(
                id: Value(urunId),
                kategoriId: Value(kategoriId),
                ad: Value(u['ad'] as String),
                aciklama: Value(u['aciklama'] as String),
                fiyat: Value((u['fiyat'] as num).toDouble()),
                gorselUrl: Value(u['gorselUrl'] as String?),
                stoktaMi: Value(u['stoktaMi'] as bool),
                oneCikanMi: Value(u['oneCikanMi'] as bool),
                seceneklerJson: Value(u['seceneklerJson'] as String),
              ),
            );
      }
    });
  }
}
