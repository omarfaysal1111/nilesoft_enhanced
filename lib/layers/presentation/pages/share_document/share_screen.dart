import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart' as c;
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

class PrintingScreen extends StatelessWidget {
  final List<SalesDtlModel> printingSalesDtlModel;
  final SalesHeadModel printingSalesHeadModel;
  final String id;
  final int numOfSerials;

  PrintingScreen({
    super.key,
    required this.printingSalesDtlModel,
    required this.printingSalesHeadModel,
    required this.id,
    required this.numOfSerials,
  });

  Future<void> generateAndSharePdf(BuildContext context) async {
    final pdf = pw.Document();
    final ttf = await rootBundle.load("fonts/Almarai-Regular.ttf");
    final arabicFont = pw.Font.ttf(ttf);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return [
            pw.Padding(
              padding: const pw.EdgeInsets.all(24.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("فاتورة مبيعات",
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(height: 12),
                  pw.Text("رقم الفاتورة: ${printingSalesHeadModel.invoiceno}",
                      style: pw.TextStyle(font: arabicFont)),
                  pw.Text("اسم العميل: ${printingSalesHeadModel.clientName}",
                      style: pw.TextStyle(font: arabicFont)),
                  pw.Text(
                      "تاريخ الفاتورة: ${intl.DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                      style: pw.TextStyle(font: arabicFont)),
                  pw.SizedBox(height: 16),
                  // ignore: deprecated_member_use
                  pw.Table.fromTextArray(
                    headers: ['الصنف', 'الكمية', 'السعر', 'الخصم', 'الاجمالي'],
                    data: printingSalesDtlModel.map((item) {
                      return [
                        item.itemName.toString(),
                        item.qty.toString(),
                        item.price.toString(),
                        item.disam.toString(),
                        (item.price! * double.parse(item.qty.toString()))
                            .toStringAsFixed(2),
                      ];
                    }).toList(),
                    headerStyle: pw.TextStyle(
                      font: arabicFont,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    cellStyle: pw.TextStyle(font: arabicFont),
                    cellAlignment: pw.Alignment.centerRight,
                    border: pw.TableBorder.all(),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 8),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        _buildSummaryRow(arabicFont, "الاجمالي",
                            printingSalesHeadModel.total),
                        _buildSummaryRow(
                            arabicFont, "الضريبة", printingSalesHeadModel.tax),
                        _buildSummaryRow(
                            arabicFont, "الخصم", printingSalesHeadModel.dis1),
                        _buildSummaryRow(arabicFont, "خصم على الفاتورة",
                            printingSalesHeadModel.disratio),
                        _buildSummaryRow(
                            arabicFont, "الصافي", printingSalesHeadModel.net,
                            isBold: true),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ];
        },
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final file = File("${outputDir.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'فاتورة المبيعات');
  }

  pw.Widget _buildSummaryRow(pw.Font font, String label, dynamic value,
      {bool isBold = false}) {
    final style = pw.TextStyle(
      font: font,
      fontSize: 12,
      fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(value.toString(), style: style),
        ],
      ),
    );
  }

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                onPressed: () async => await generateAndSharePdf(context),
                text: ("مشاركة الفاتورة"),
              ),
              CustomButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => HomeBloc(),
                        child: const HomePage(),
                      ),
                    ),
                  );
                },
                text: ("الي الرئيسية"),
              ),
            ],
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    "مشاركة الفاتورة",
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: RepaintBoundary(
                  key: _globalKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "رقم الفاتورة: ${printingSalesHeadModel.invoiceno}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          "العميل: ${printingSalesHeadModel.clientName}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Almarai',
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const Divider(thickness: 1.5),
                        Text(
                          "التاريخ: ${c.DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontFamily: 'Almarai'),
                        ),
                        const SizedBox(height: 12),
                        Table(
                          border: TableBorder.symmetric(
                            inside: BorderSide(color: Colors.grey.shade300),
                            outside: const BorderSide(
                                color: Colors.black, width: 1.5),
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1.2),
                            2: FlexColumnWidth(1.2),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1.5),
                          },
                          children: _buildTableRows(),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryCard(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              _buildSummaryRow2('الاجمالي', "${printingSalesHeadModel.total}"),
              _buildSummaryRow2('الضريبة', "${printingSalesHeadModel.tax}"),
              _buildSummaryRow2('الخصم', "${printingSalesHeadModel.dis1}"),
              _buildSummaryRow2(
                  'الخصم علي الفاتورة', "${printingSalesHeadModel.disam}"),
              const Divider(),
              _buildSummaryRow2('الصافي', "${printingSalesHeadModel.net}",
                  isBold: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow2(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    return [
      TableRow(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        children: const [
          Padding(
              padding: EdgeInsets.all(8),
              child: Text('الصنف', textAlign: TextAlign.center)),
          Padding(
              padding: EdgeInsets.all(8),
              child: Text('الكمية', textAlign: TextAlign.center)),
          Padding(
              padding: EdgeInsets.all(8),
              child: Text('السعر', textAlign: TextAlign.center)),
          Padding(
              padding: EdgeInsets.all(8),
              child: Text('الخصم', textAlign: TextAlign.center)),
          Padding(
              padding: EdgeInsets.all(8),
              child: Text('الاجمالي', textAlign: TextAlign.center)),
        ],
      ),
      ...printingSalesDtlModel.map((item) => TableRow(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(item.itemName ?? '', textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(item.qty.toString(), textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(item.price.toString(), textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(item.disam.toString(), textAlign: TextAlign.center)),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (item.price! * double.parse(item.qty.toString()))
                        .toString(),
                    textAlign: TextAlign.center,
                  )),
            ],
          )),
    ];
  }
}
