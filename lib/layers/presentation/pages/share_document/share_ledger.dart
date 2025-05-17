// ledger_pdf_generator.dart
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_model.dart';
import 'package:intl/intl.dart';

Future<void> generateAndShareLedgerPdf({
  required List<LedgerModel> ledgers,
  required String customerName,
  required String fromDate,
  required String toDate,
  required String openbal,
  required String debit,
  required String credit,
  required String currentbal,
}) async {
  final pdf = pw.Document();
  final headers = ['التاريخ', 'البيان', 'نوع', 'رقم', 'مدين', 'دائن', 'الرصيد'];
  final format = NumberFormat('#,##0.00', 'en');

  List<pw.TableRow> buildTableRows() {
    return [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey300),
        children: headers
            .map((h) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(h,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ))
            .toList(),
      ),
      ...ledgers.map((item) {
        return pw.TableRow(
          children: [
            item.docdate,
            item.descr,
            item.doctype,
            item.docno,
            format.format(item.debit ?? 0),
            format.format(item.cridet ?? 0),
            format.format(item.balance ?? 0),
          ]
              .map((text) => pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(text ?? '', textAlign: pw.TextAlign.center),
                  ))
              .toList(),
        );
      }),
    ];
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => [
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('تقرير كشف حساب العميل',
                  style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 5),
              pw.Text('العميل: $customerName'),
              pw.Text('من: $fromDate  إلى: $toDate'),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: buildTableRows(),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                  'الرصيد الافتتاحي: ${format.format(double.parse(openbal))}'),
              pw.Text('إجمالي المدين: ${format.format(double.parse(debit))}'),
              pw.Text('إجمالي الدائن: ${format.format(double.parse(credit))}'),
              pw.Text(
                  'الرصيد الحالي: ${format.format(double.parse(currentbal))}'),
            ],
          ),
        ),
      ],
    ),
  );

  final outputDir = await getTemporaryDirectory();
  final pdfFile = File("${outputDir.path}/ledger_report.pdf");
  await pdfFile.writeAsBytes(await pdf.save());

  await Share.shareXFiles([XFile(pdfFile.path)], text: 'تقرير كشف حساب العميل');
}
