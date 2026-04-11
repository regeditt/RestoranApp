import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

/// Siparis verilerini gunluk/aylik ozetler halinde CSV veya PDF olarak disa aktarir.
class RaporDisaAktarimServisi {
  const RaporDisaAktarimServisi();

  Future<String?> gunlukCsvDisaAktar(List<SiparisVarligi> siparisler) {
    return _csvDisaAktar(siparisler: siparisler, aylik: false);
  }

  Future<String?> aylikCsvDisaAktar(List<SiparisVarligi> siparisler) {
    return _csvDisaAktar(siparisler: siparisler, aylik: true);
  }

  Future<void> gunlukPdfYazdir(List<SiparisVarligi> siparisler) {
    return _pdfYazdir(siparisler: siparisler, aylik: false);
  }

  Future<void> aylikPdfYazdir(List<SiparisVarligi> siparisler) {
    return _pdfYazdir(siparisler: siparisler, aylik: true);
  }

  @visibleForTesting
  String csvMetniOlustur({
    required List<SiparisVarligi> siparisler,
    required bool aylik,
  }) {
    final List<_DonemOzetiSatiri> satirlar = _ozetSatirlariOlustur(
      siparisler: siparisler,
      aylik: aylik,
    );
    final _DonemToplami genelToplam = _genelToplamHesapla(satirlar);

    final List<List<String>> tumSatirlar = <List<String>>[
      <String>[
        'Donem',
        'Siparis adedi',
        'Brut ciro',
        'Kampanya indirimi',
        'Net ciro',
        'Kuponlu siparis',
      ],
      ...satirlar.map(
        (_DonemOzetiSatiri satir) => <String>[
          satir.donemEtiketi,
          satir.toplam.adet.toString(),
          _ondalikYaz(satir.toplam.brutCiro),
          _ondalikYaz(satir.toplam.indirimToplami),
          _ondalikYaz(satir.toplam.netCiro),
          satir.toplam.kuponluSiparis.toString(),
        ],
      ),
      <String>[
        'Toplam',
        genelToplam.adet.toString(),
        _ondalikYaz(genelToplam.brutCiro),
        _ondalikYaz(genelToplam.indirimToplami),
        _ondalikYaz(genelToplam.netCiro),
        genelToplam.kuponluSiparis.toString(),
      ],
    ];

    return tumSatirlar
        .map((List<String> satir) => satir.map(_csvHucreYaz).join(';'))
        .join('\n');
  }

  Future<String?> _csvDisaAktar({
    required List<SiparisVarligi> siparisler,
    required bool aylik,
  }) async {
    final String csv = csvMetniOlustur(siparisler: siparisler, aylik: aylik);
    final Uint8List bytes = Uint8List.fromList(utf8.encode(csv));
    return FilePicker.saveFile(
      dialogTitle: aylik
          ? 'Aylik raporu CSV olarak kaydet'
          : 'Gunluk raporu CSV olarak kaydet',
      fileName: _dosyaAdiOlustur(aylik: aylik, uzanti: 'csv'),
      type: FileType.custom,
      allowedExtensions: const <String>['csv'],
      bytes: bytes,
    );
  }

  Future<void> _pdfYazdir({
    required List<SiparisVarligi> siparisler,
    required bool aylik,
  }) async {
    final Uint8List pdfBytes = await _pdfOlustur(
      siparisler: siparisler,
      aylik: aylik,
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat _) async => pdfBytes);
  }

  Future<Uint8List> _pdfOlustur({
    required List<SiparisVarligi> siparisler,
    required bool aylik,
  }) async {
    final List<_DonemOzetiSatiri> satirlar = _ozetSatirlariOlustur(
      siparisler: siparisler,
      aylik: aylik,
    );
    final _DonemToplami genelToplam = _genelToplamHesapla(satirlar);
    final pw.Document belge = pw.Document();
    final DateTime simdi = DateTime.now();
    final String baslik = aylik ? 'Aylik satis raporu' : 'Gunluk satis raporu';

    belge.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text(
              baslik,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Olusturma zamani: ${_tarihSaatYaz(simdi)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 12),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blueGrey800,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headers: const <String>[
                'Donem',
                'Siparis adedi',
                'Brut ciro',
                'Kampanya indirimi',
                'Net ciro',
                'Kuponlu siparis',
              ],
              data: satirlar
                  .map(
                    (_DonemOzetiSatiri satir) => <String>[
                      satir.donemEtiketi,
                      satir.toplam.adet.toString(),
                      _ondalikYaz(satir.toplam.brutCiro),
                      _ondalikYaz(satir.toplam.indirimToplami),
                      _ondalikYaz(satir.toplam.netCiro),
                      satir.toplam.kuponluSiparis.toString(),
                    ],
                  )
                  .toList(growable: false),
              columnWidths: <int, pw.TableColumnWidth>{
                0: const pw.FlexColumnWidth(1.4),
                1: const pw.FlexColumnWidth(0.9),
                2: const pw.FlexColumnWidth(1.0),
                3: const pw.FlexColumnWidth(1.1),
                4: const pw.FlexColumnWidth(1.0),
                5: const pw.FlexColumnWidth(0.9),
              },
            ),
            pw.SizedBox(height: 12),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey500),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Text(
                'Toplam siparis: ${genelToplam.adet} | '
                'Brut: ${_ondalikYaz(genelToplam.brutCiro)} TL | '
                'Indirim: ${_ondalikYaz(genelToplam.indirimToplami)} TL | '
                'Net: ${_ondalikYaz(genelToplam.netCiro)} TL | '
                'Kuponlu siparis: ${genelToplam.kuponluSiparis}',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ];
        },
      ),
    );

    return belge.save();
  }

  List<_DonemOzetiSatiri> _ozetSatirlariOlustur({
    required List<SiparisVarligi> siparisler,
    required bool aylik,
  }) {
    final Map<String, _DonemToplami> donemToplamlari =
        <String, _DonemToplami>{};

    for (final SiparisVarligi siparis in siparisler) {
      final String anahtar = _donemAnahtari(
        siparis.olusturmaTarihi,
        aylik: aylik,
      );
      final _DonemToplami toplam = donemToplamlari.putIfAbsent(
        anahtar,
        _DonemToplami.new,
      );
      toplam.siparisEkle(siparis);
    }

    final List<String> siraliAnahtarlar = donemToplamlari.keys.toList()..sort();
    return siraliAnahtarlar
        .map(
          (String anahtar) => _DonemOzetiSatiri(
            donemEtiketi: anahtar,
            toplam: donemToplamlari[anahtar]!,
          ),
        )
        .toList(growable: false);
  }

  _DonemToplami _genelToplamHesapla(List<_DonemOzetiSatiri> satirlar) {
    final _DonemToplami genelToplam = _DonemToplami();
    for (final _DonemOzetiSatiri satir in satirlar) {
      genelToplam.adet += satir.toplam.adet;
      genelToplam.brutCiro += satir.toplam.brutCiro;
      genelToplam.indirimToplami += satir.toplam.indirimToplami;
      genelToplam.netCiro += satir.toplam.netCiro;
      genelToplam.kuponluSiparis += satir.toplam.kuponluSiparis;
    }
    return genelToplam;
  }

  String _donemAnahtari(DateTime tarih, {required bool aylik}) {
    final String yil = tarih.year.toString().padLeft(4, '0');
    final String ay = tarih.month.toString().padLeft(2, '0');
    if (aylik) {
      return '$yil-$ay';
    }
    final String gun = tarih.day.toString().padLeft(2, '0');
    return '$yil-$ay-$gun';
  }

  String _dosyaAdiOlustur({required bool aylik, required String uzanti}) {
    final DateTime simdi = DateTime.now();
    final String damga =
        '${simdi.year.toString().padLeft(4, '0')}'
        '${simdi.month.toString().padLeft(2, '0')}'
        '${simdi.day.toString().padLeft(2, '0')}_'
        '${simdi.hour.toString().padLeft(2, '0')}'
        '${simdi.minute.toString().padLeft(2, '0')}';
    final String tur = aylik ? 'aylik' : 'gunluk';
    return 'rapor_${tur}_$damga.$uzanti';
  }

  String _ondalikYaz(double deger) => deger.toStringAsFixed(2);

  String _csvHucreYaz(String deger) {
    if (!deger.contains(';') && !deger.contains('"') && !deger.contains('\n')) {
      return deger;
    }
    final String kacisli = deger.replaceAll('"', '""');
    return '"$kacisli"';
  }

  String _tarihSaatYaz(DateTime tarih) {
    final String yil = tarih.year.toString().padLeft(4, '0');
    final String ay = tarih.month.toString().padLeft(2, '0');
    final String gun = tarih.day.toString().padLeft(2, '0');
    final String saat = tarih.hour.toString().padLeft(2, '0');
    final String dakika = tarih.minute.toString().padLeft(2, '0');
    return '$yil-$ay-$gun $saat:$dakika';
  }
}

class _DonemOzetiSatiri {
  _DonemOzetiSatiri({required this.donemEtiketi, required this.toplam});

  final String donemEtiketi;
  final _DonemToplami toplam;
}

class _DonemToplami {
  int adet = 0;
  double brutCiro = 0;
  double indirimToplami = 0;
  double netCiro = 0;
  int kuponluSiparis = 0;

  void siparisEkle(SiparisVarligi siparis) {
    adet++;
    brutCiro += siparis.araToplam;
    indirimToplami += siparis.indirimTutari;
    netCiro += siparis.toplamTutar;
    if (siparis.indirimTutari > 0 || (siparis.kuponKodu ?? '').isNotEmpty) {
      kuponluSiparis++;
    }
  }
}
