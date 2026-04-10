import 'dart:convert';

import 'package:restoran_app/ortak/veri/veritabani.dart';
import 'package:restoran_app/ozellikler/siparis/alan/depolar/kurye_entegrasyon_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';

class KuryeEntegrasyonDeposuSqlite implements KuryeEntegrasyonDeposu {
  KuryeEntegrasyonDeposuSqlite(this._veritabani);

  static const String saglayiciAyarAnahtari = 'kurye_takip_saglayicilar_v1';
  static const String eslesmeAyarAnahtari = 'kurye_takip_eslesmeler_v1';

  final UygulamaVeritabani _veritabani;

  @override
  Future<KuryeEntegrasyonDepoKaydi?> yukle() async {
    final String? saglayiciJson = await _veritabani.ayarOku(
      saglayiciAyarAnahtari,
    );
    final String? eslesmeJson = await _veritabani.ayarOku(eslesmeAyarAnahtari);
    if (_bosMu(saglayiciJson) && _bosMu(eslesmeJson)) {
      return null;
    }
    return KuryeEntegrasyonDepoKaydi(
      saglayicilar: _saglayicilariJsondanCoz(saglayiciJson),
      eslesmeler: _eslesmeleriJsondanCoz(eslesmeJson),
    );
  }

  @override
  Future<void> kaydet(KuryeEntegrasyonDepoKaydi kayit) async {
    final String saglayiciJson = jsonEncode(
      kayit.saglayicilar.map(_saglayiciyiJsonaDonustur).toList(),
    );
    final String eslesmeJson = jsonEncode(
      kayit.eslesmeler.map(_eslesmeyiJsonaDonustur).toList(),
    );
    await _veritabani.ayarYaz(saglayiciAyarAnahtari, saglayiciJson);
    await _veritabani.ayarYaz(eslesmeAyarAnahtari, eslesmeJson);
  }

  List<KuryeTakipSaglayiciVarligi> _saglayicilariJsondanCoz(String? jsonVeri) {
    if (_bosMu(jsonVeri)) {
      return const <KuryeTakipSaglayiciVarligi>[];
    }
    final dynamic ham = _guvenliJsonCoz(jsonVeri!);
    if (ham is! List) {
      return const <KuryeTakipSaglayiciVarligi>[];
    }
    final List<KuryeTakipSaglayiciVarligi> sonuc =
        <KuryeTakipSaglayiciVarligi>[];
    for (final dynamic item in ham) {
      if (item is! Map) {
        continue;
      }
      final Map<String, Object?> kayit = Map<String, Object?>.from(item);
      final String id = (kayit['id'] as String? ?? '').trim();
      final String ad = (kayit['ad'] as String? ?? '').trim();
      if (id.isEmpty || ad.isEmpty) {
        continue;
      }
      final int turIndex = (kayit['tur'] as num?)?.toInt() ?? 0;
      final KuryeTakipSaglayiciTuru tur = KuryeTakipSaglayiciTuru
          .values[turIndex.clamp(0, KuryeTakipSaglayiciTuru.values.length - 1)];
      sonuc.add(
        KuryeTakipSaglayiciVarligi(
          id: id,
          ad: ad,
          tur: tur,
          apiTabanUrl: (kayit['apiTabanUrl'] as String? ?? '').trim(),
          apiAnahtari: (kayit['apiAnahtari'] as String? ?? '').trim(),
          aktifMi: _boolDegeriCoz(kayit['aktifMi']),
          oncelik: (kayit['oncelik'] as num?)?.toInt() ?? (sonuc.length + 1),
          aciklama: (kayit['aciklama'] as String? ?? '').trim(),
        ),
      );
    }
    return sonuc;
  }

  List<KuryeCihazEslesmesiVarligi> _eslesmeleriJsondanCoz(String? jsonVeri) {
    if (_bosMu(jsonVeri)) {
      return const <KuryeCihazEslesmesiVarligi>[];
    }
    final dynamic ham = _guvenliJsonCoz(jsonVeri!);
    if (ham is! List) {
      return const <KuryeCihazEslesmesiVarligi>[];
    }
    final List<KuryeCihazEslesmesiVarligi> sonuc =
        <KuryeCihazEslesmesiVarligi>[];
    for (final dynamic item in ham) {
      if (item is! Map) {
        continue;
      }
      final Map<String, Object?> kayit = Map<String, Object?>.from(item);
      final String kuryeAdi = (kayit['kuryeAdi'] as String? ?? '').trim();
      final String saglayiciId = (kayit['saglayiciId'] as String? ?? '').trim();
      final String cihazKimligi = (kayit['cihazKimligi'] as String? ?? '')
          .trim();
      if (kuryeAdi.isEmpty || saglayiciId.isEmpty || cihazKimligi.isEmpty) {
        continue;
      }
      sonuc.add(
        KuryeCihazEslesmesiVarligi(
          kuryeAdi: kuryeAdi,
          saglayiciId: saglayiciId,
          cihazKimligi: cihazKimligi,
          aktifMi: _boolDegeriCoz(kayit['aktifMi']),
        ),
      );
    }
    return sonuc;
  }

  Map<String, Object?> _saglayiciyiJsonaDonustur(
    KuryeTakipSaglayiciVarligi saglayici,
  ) {
    return <String, Object?>{
      'id': saglayici.id,
      'ad': saglayici.ad,
      'tur': saglayici.tur.index,
      'apiTabanUrl': saglayici.apiTabanUrl,
      'apiAnahtari': saglayici.apiAnahtari,
      'aktifMi': saglayici.aktifMi,
      'oncelik': saglayici.oncelik,
      'aciklama': saglayici.aciklama,
    };
  }

  Map<String, Object?> _eslesmeyiJsonaDonustur(
    KuryeCihazEslesmesiVarligi eslesme,
  ) {
    return <String, Object?>{
      'kuryeAdi': eslesme.kuryeAdi,
      'saglayiciId': eslesme.saglayiciId,
      'cihazKimligi': eslesme.cihazKimligi,
      'aktifMi': eslesme.aktifMi,
    };
  }

  bool _bosMu(String? metin) {
    return metin == null || metin.trim().isEmpty;
  }

  bool _boolDegeriCoz(Object? ham) {
    return switch (ham) {
      bool deger => deger,
      num deger => deger != 0,
      String deger => deger.toLowerCase() == 'true' || deger == '1',
      _ => false,
    };
  }

  dynamic _guvenliJsonCoz(String jsonVeri) {
    try {
      return jsonDecode(jsonVeri);
    } catch (_) {
      return null;
    }
  }
}
