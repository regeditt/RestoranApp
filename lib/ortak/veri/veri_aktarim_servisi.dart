import 'package:drift/drift.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class VeriAktarimServisi {
  VeriAktarimServisi(this._veritabani);

  final UygulamaVeritabani _veritabani;

  Future<Map<String, Object?>> menuDisaAktar() async {
    final kategoriler = await _veritabani.select(_veritabani.kategoriKayitlari).get();
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

      for (final ham in kategoriHam) {
        final Map<String, Object?> k = Map<String, Object?>.from(ham as Map);
        await _veritabani.into(_veritabani.kategoriKayitlari).insertOnConflictUpdate(
              KategoriKayitlariCompanion(
                id: Value(k['id'] as String),
                ad: Value(k['ad'] as String),
                sira: Value((k['sira'] as num).toInt()),
                acikMi: Value(k['acikMi'] as bool),
              ),
            );
      }

      for (final ham in urunHam) {
        final Map<String, Object?> u = Map<String, Object?>.from(ham as Map);
        await _veritabani.into(_veritabani.urunKayitlari).insertOnConflictUpdate(
              UrunKayitlariCompanion(
                id: Value(u['id'] as String),
                kategoriId: Value(u['kategoriId'] as String),
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
