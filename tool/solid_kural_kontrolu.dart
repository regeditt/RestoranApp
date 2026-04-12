import 'dart:io';

const String _projePaketi = 'package:restoran_app/';
const String _baselineYolu = 'tool/solid_kural_baseline.txt';

const Map<String, String> _katmanTakmaAdlari = <String, String>{
  'core': 'alan',
  'providers': 'veri',
};

const Map<String, Set<String>> _ayniModulIzinleri = <String, Set<String>>{
  'sunum': <String>{'sunum', 'uygulama', 'alan'},
  'uygulama': <String>{'uygulama', 'alan'},
  'alan': <String>{'alan'},
  'veri': <String>{'veri', 'alan'},
};

const Map<String, Set<String>> _farkliModulIzinleri = <String, Set<String>>{
  'sunum': <String>{'alan'},
  'uygulama': <String>{'alan'},
  'alan': <String>{'alan'},
  'veri': <String>{'alan'},
};

final RegExp _ozellikYoluDeseni = RegExp(r'^lib/ozellikler/([^/]+)/([^/]+)/');
final RegExp _importDeseni = RegExp(r"^\s*import\s+'([^']+)';");
final RegExp _flutterImportDeseni = RegExp(r"^\s*import\s+'package:flutter/");
final RegExp _gercekMockMirasDeseni = RegExp(
  r'class\s+\w+\s+extends\s+\w*Mock\b',
);

void main(List<String> args) {
  final bool baselineGuncelle = args.contains('--update-baseline');
  final List<Ihlal> tumIhlaller = _ihlalleriTopla();
  final Set<String> tumKimlikler = tumIhlaller
      .map((Ihlal ihlal) => ihlal.kimlik)
      .toSet();

  if (baselineGuncelle) {
    _baselineYaz(tumKimlikler);
    stdout.writeln(
      'SOLID baseline guncellendi: ${tumKimlikler.length} kayit -> $_baselineYolu',
    );
    return;
  }

  final Set<String> baseline = _baselineOku();
  final List<Ihlal> yeniIhlaller =
      tumIhlaller
          .where((Ihlal ihlal) => !baseline.contains(ihlal.kimlik))
          .toList()
        ..sort((Ihlal a, Ihlal b) {
          final int dosyaKarsilastirma = a.kaynakYol.compareTo(b.kaynakYol);
          if (dosyaKarsilastirma != 0) {
            return dosyaKarsilastirma;
          }
          return a.satir.compareTo(b.satir);
        });

  final Set<String> artikKullanilmayanBaseline = baseline.difference(
    tumKimlikler,
  );

  if (yeniIhlaller.isNotEmpty) {
    stderr.writeln(
      'Yeni SOLID/modul ihlalleri bulundu: ${yeniIhlaller.length}',
    );
    for (final Ihlal ihlal in yeniIhlaller) {
      stderr.writeln(
        '- ${ihlal.kaynakYol}:${ihlal.satir} [${ihlal.kuralKodu}] ${ihlal.aciklama} (${ihlal.hedef})',
      );
    }
    stderr.writeln(
      '\nNot: Bu ihlaller beklenen legacy borc ise once kodu duzeltin; '
      'zorunlu durumda baseline guncellemek icin `--update-baseline` kullanin.',
    );
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'SOLID kontrolu basarili. Yeni ihlal yok. '
    '(toplam ihlal: ${tumIhlaller.length}, baseline: ${baseline.length})',
  );

  if (artikKullanilmayanBaseline.isNotEmpty) {
    stdout.writeln(
      'Temizlenebilecek baseline kaydi: ${artikKullanilmayanBaseline.length}',
    );
  }
}

List<Ihlal> _ihlalleriTopla() {
  final Directory libKlasoru = Directory('lib');
  if (!libKlasoru.existsSync()) {
    throw StateError(
      'lib klasoru bulunamadi. Komutu proje kokunden calistirin.',
    );
  }

  final List<Ihlal> ihlaller = <Ihlal>[];
  final Iterable<File> dosyalar = libKlasoru
      .listSync(recursive: true)
      .whereType<File>()
      .where((File dosya) => dosya.path.endsWith('.dart'));

  for (final File dosya in dosyalar) {
    final String goreliYol = _normalizeYol(dosya.path);
    if (_uretildiDosyaMi(goreliYol)) {
      continue;
    }

    final KatmanBilgisi? kaynak = _katmanBilgisiCoz(goreliYol);
    if (kaynak == null) {
      continue;
    }

    final List<String> satirlar = dosya.readAsLinesSync();
    ihlaller.addAll(_importIhlalleriniBul(kaynak, goreliYol, satirlar));
    ihlaller.addAll(_gercekMockIhlalleriniBul(kaynak, goreliYol, satirlar));
  }

  return ihlaller;
}

List<Ihlal> _importIhlalleriniBul(
  KatmanBilgisi kaynak,
  String kaynakYol,
  List<String> satirlar,
) {
  final List<Ihlal> ihlaller = <Ihlal>[];

  for (int i = 0; i < satirlar.length; i++) {
    final String satir = satirlar[i];

    if (kaynak.katman == 'alan' && _flutterImportDeseni.hasMatch(satir)) {
      ihlaller.add(
        Ihlal(
          kaynakYol: kaynakYol,
          satir: i + 1,
          hedef: 'package:flutter/*',
          kuralKodu: 'alan_flutter_bagimliligi',
          aciklama: 'Alan katmaninda Flutter bagimliligi olamaz.',
        ),
      );
    }

    final Match? eslesme = _importDeseni.firstMatch(satir);
    if (eslesme == null) {
      continue;
    }

    final String importYolu = eslesme.group(1)!;
    if (!importYolu.startsWith(_projePaketi)) {
      continue;
    }

    final String hedefGoreliYol = importYolu.substring(_projePaketi.length);
    final KatmanBilgisi? hedef = _katmanBilgisiCoz(hedefGoreliYol);
    if (hedef == null) {
      continue;
    }

    if (kaynak.modul == hedef.modul) {
      final Set<String> izinliKatmanlar =
          _ayniModulIzinleri[kaynak.katman] ?? <String>{};
      if (!izinliKatmanlar.contains(hedef.katman)) {
        ihlaller.add(
          Ihlal(
            kaynakYol: kaynakYol,
            satir: i + 1,
            hedef: importYolu,
            kuralKodu: 'katman_sinir_ihlali',
            aciklama:
                '${kaynak.katman} katmani ayni modulde ${hedef.katman} katmanina baglanamaz.',
          ),
        );
      }
      continue;
    }

    final Set<String> izinliKatmanlar =
        _farkliModulIzinleri[kaynak.katman] ?? <String>{};
    if (!izinliKatmanlar.contains(hedef.katman)) {
      ihlaller.add(
        Ihlal(
          kaynakYol: kaynakYol,
          satir: i + 1,
          hedef: importYolu,
          kuralKodu: 'modul_sinir_ihlali',
          aciklama:
              '${kaynak.katman} katmani farkli modulde yalnizca alan katmanina baglanabilir.',
        ),
      );
    }
  }

  return ihlaller;
}

List<Ihlal> _gercekMockIhlalleriniBul(
  KatmanBilgisi kaynak,
  String kaynakYol,
  List<String> satirlar,
) {
  final List<Ihlal> ihlaller = <Ihlal>[];
  if (kaynak.katman != 'veri' || !kaynakYol.endsWith('_gercek.dart')) {
    return ihlaller;
  }

  for (int i = 0; i < satirlar.length; i++) {
    final String satir = satirlar[i];
    if (_gercekMockMirasDeseni.hasMatch(satir)) {
      ihlaller.add(
        Ihlal(
          kaynakYol: kaynakYol,
          satir: i + 1,
          hedef: 'extends *Mock',
          kuralKodu: 'gercek_mock_miras_ihlali',
          aciklama:
              'Gercek depo, mock sinifindan kalitim almamali; ortak kontrati implemente etmelidir.',
        ),
      );
    }
  }
  return ihlaller;
}

KatmanBilgisi? _katmanBilgisiCoz(String yol) {
  final Match? eslesme = _ozellikYoluDeseni.firstMatch(_normalizeYol(yol));
  if (eslesme == null) {
    return null;
  }

  final String modul = eslesme.group(1)!;
  final String hamKatman = eslesme.group(2)!;
  final String katman = _katmanTakmaAdlari[hamKatman] ?? hamKatman;
  if (!_ayniModulIzinleri.containsKey(katman)) {
    return null;
  }

  return KatmanBilgisi(modul: modul, katman: katman);
}

Set<String> _baselineOku() {
  final File baseline = File(_baselineYolu);
  if (!baseline.existsSync()) {
    return <String>{};
  }

  return baseline
      .readAsLinesSync()
      .map((String satir) => satir.trim())
      .where((String satir) => satir.isNotEmpty && !satir.startsWith('#'))
      .toSet();
}

void _baselineYaz(Set<String> kayitlar) {
  final File baseline = File(_baselineYolu);
  baseline.createSync(recursive: true);

  final List<String> satirlar = <String>[
    '# SOLID kural baseline',
    '# Format: kaynak|hedef|kuralKodu',
    ...kayitlar.toList()..sort(),
  ];

  baseline.writeAsStringSync('${satirlar.join('\n')}\n');
}

bool _uretildiDosyaMi(String goreliYol) {
  return goreliYol.endsWith('.g.dart') ||
      goreliYol.endsWith('.freezed.dart') ||
      goreliYol.endsWith('.gr.dart');
}

String _normalizeYol(String yol) => yol.replaceAll('\\', '/');

class KatmanBilgisi {
  KatmanBilgisi({required this.modul, required this.katman});

  final String modul;
  final String katman;
}

class Ihlal {
  Ihlal({
    required this.kaynakYol,
    required this.satir,
    required this.hedef,
    required this.kuralKodu,
    required this.aciklama,
  });

  final String kaynakYol;
  final int satir;
  final String hedef;
  final String kuralKodu;
  final String aciklama;

  String get kimlik => '$kaynakYol|$hedef|$kuralKodu';
}
