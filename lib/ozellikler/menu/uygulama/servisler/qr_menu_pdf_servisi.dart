import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_karti_varligi.dart';

class QrMenuPdfServisi {
  const QrMenuPdfServisi._();

  static Future<void> kartlariYazdir({
    required String belgeBasligi,
    required List<QrMenuKartiVarligi> kartlar,
  }) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return _pdfOlustur(belgeBasligi: belgeBasligi, kartlar: kartlar);
      },
      name: belgeBasligi,
    );
  }

  static Future<Uint8List> _pdfOlustur({
    required String belgeBasligi,
    required List<QrMenuKartiVarligi> kartlar,
  }) async {
    final pw.Document belge = pw.Document();

    belge.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(18),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F3EAF8'),
                borderRadius: pw.BorderRadius.circular(16),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    UygulamaSabitleri.restoranAdi.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#B54B74'),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    belgeBasligi,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${kartlar.length} adet QR karti',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Wrap(
              spacing: 16,
              runSpacing: 16,
              children: kartlar.map(_qrKartiniOlustur).toList(),
            ),
          ];
        },
      ),
    );

    return belge.save();
  }

  static pw.Widget _qrKartiniOlustur(QrMenuKartiVarligi kart) {
    return pw.Container(
      width: 245,
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColor.fromHex('#DDD1E8')),
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: <pw.Widget>[
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#FCE3EC'),
              borderRadius: pw.BorderRadius.circular(999),
            ),
            child: pw.Text(
              UygulamaSabitleri.tamMarkaAdi,
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#A13A63'),
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            kart.baslik,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            kart.altBaslik,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColor.fromHex('#E6DDEA')),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: kart.url,
              width: 140,
              height: 140,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            kart.url,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
            maxLines: 3,
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Tarat ve masaya ozel menuye ulas',
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }
}
