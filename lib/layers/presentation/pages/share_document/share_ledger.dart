// ledger_pdf_generator.dart
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
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

  // Load Arabic font
  final fontData = await rootBundle.load('fonts/Almarai-Regular.ttf');
  final arabicFont = pw.Font.ttf(fontData);

  // Number of rows per page - increased to reduce total pages
  // Landscape A4 can fit approximately 35-40 rows with compact styling
  const int rowsPerPage = 40;
  
  // Maximum pages limit to prevent PDF library errors
  const int maxPages = 20;
  
  // Store original length to check if truncated
  final originalLedgerCount = ledgers.length;
  
  // Split ledgers into chunks
  int totalPages = (ledgers.length / rowsPerPage).ceil();
  
  // Limit total pages to prevent PDF library errors
  bool isTruncated = false;
  if (totalPages > maxPages) {
    totalPages = maxPages;
    // Truncate ledgers to fit within max pages
    ledgers = ledgers.take(rowsPerPage * maxPages).toList();
    isTruncated = true;
  }
  
  // Build header row - more compact
  pw.TableRow buildHeaderRow() {
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: PdfColors.grey300),
      children: headers
          .map((h) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                child: pw.Text(h,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        font: arabicFont, 
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8)),
              ))
          .toList(),
    );
  }

  // Build table rows for a specific range
  List<pw.TableRow> buildTableRows(int startIndex, int endIndex) {
    final rows = <pw.TableRow>[buildHeaderRow()];
    
    for (int i = startIndex; i < endIndex && i < ledgers.length; i++) {
      final item = ledgers[i];
      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: pw.Text(
                item.docdate ?? '',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: arabicFont, fontSize: 7),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: pw.Text(
                item.descr ?? '',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: arabicFont, fontSize: 7),
                maxLines: 1,
                overflow: pw.TextOverflow.clip,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: pw.Text(
                item.doctype ?? '',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: arabicFont, fontSize: 7),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: pw.Text(
                item.docno ?? '',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: arabicFont, fontSize: 7),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: pw.Text(
                format.format(item.debit ?? 0),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: arabicFont, fontSize: 7),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: pw.Text(
                format.format(item.cridet ?? 0),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: arabicFont, fontSize: 7),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: pw.Text(
                format.format(item.balance ?? 0),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: arabicFont, fontSize: 7),
              ),
            ),
          ],
        ),
      );
    }
    
    return rows;
  }

  // Build header section (repeated on each page) - more compact
  pw.Widget buildPageHeader(int currentPage, int totalPages, bool isTruncated) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('تقرير كشف حساب العميل',
                  style: pw.TextStyle(fontSize: 14, font: arabicFont, fontWeight: pw.FontWeight.bold)),
              if (totalPages > 1)
                pw.Text('صفحة $currentPage من $totalPages',
                    style: pw.TextStyle(font: arabicFont, fontSize: 8, color: PdfColors.grey700)),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Text('العميل: $customerName',
              style: pw.TextStyle(font: arabicFont, fontSize: 9)),
          pw.Text('من: $fromDate  إلى: $toDate',
              style: pw.TextStyle(font: arabicFont, fontSize: 9)),
          if (isTruncated)
            pw.Text('⚠️ تم عرض أول ${ledgers.length} سجل فقط',
                style: pw.TextStyle(font: arabicFont, fontSize: 8, color: PdfColors.red700)),
          pw.SizedBox(height: 3),
        ],
      ),
    );
  }

  // Build footer section (only on last page)
  pw.Widget buildPageFooter(bool isLastPage) {
    if (!isLastPage) return pw.SizedBox.shrink();
    
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 10),
          pw.Divider(),
          pw.SizedBox(height: 5),
          pw.Text('الرصيد الافتتاحي: ${format.format(double.parse(openbal))}',
              style: pw.TextStyle(font: arabicFont, fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text('إجمالي المدين: ${format.format(double.parse(debit))}',
              style: pw.TextStyle(font: arabicFont, fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text('إجمالي الدائن: ${format.format(double.parse(credit))}',
              style: pw.TextStyle(font: arabicFont, fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text('الرصيد الحالي: ${format.format(double.parse(currentbal))}',
              style: pw.TextStyle(font: arabicFont, fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  // Generate pages
  for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
    final startIndex = pageIndex * rowsPerPage;
    final endIndex = (pageIndex + 1) * rowsPerPage;
    final isLastPage = pageIndex == totalPages - 1;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(15),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildPageHeader(pageIndex + 1, totalPages, isTruncated && pageIndex == 0),
                pw.Expanded(
                  child: pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(1.1),
                      1: const pw.FlexColumnWidth(2.2),
                      2: const pw.FlexColumnWidth(0.8),
                      3: const pw.FlexColumnWidth(0.9),
                      4: const pw.FlexColumnWidth(1.1),
                      5: const pw.FlexColumnWidth(1.1),
                      6: const pw.FlexColumnWidth(1.1),
                    },
                    children: buildTableRows(startIndex, endIndex),
                  ),
                ),
                buildPageFooter(isLastPage),
              ],
            ),
          );
        },
      ),
    );
  }

  final outputDir = await getTemporaryDirectory();
  final pdfFile = File("${outputDir.path}/ledger_report.pdf");
  await pdfFile.writeAsBytes(await pdf.save());

  await Share.shareXFiles([XFile(pdfFile.path)], text: 'تقرير كشف حساب العميل');
}
