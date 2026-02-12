import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as c;
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as intl;
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart'; // Make sure this is imported

class ShareCashin extends StatelessWidget {
  final CashinModel printingCashinHeadModel;
  final String id;
  final int numOfSerials;

  ShareCashin({
    super.key,
    required this.printingCashinHeadModel,
    required this.id,
    required this.numOfSerials,
  });

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future<void> captureAndSharePdf() async {
      try {
        final pdf = pw.Document();

        final arabicFont = await rootBundle.load("fonts/Almarai-Regular.ttf");
        final ttf = pw.Font.ttf(arabicFont);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      "مشاركة سند القبض النقدي",
                      style: pw.TextStyle(
                          font: ttf,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 16),
                    pw.Text("العميل: ${printingCashinHeadModel.clint}",
                        style: pw.TextStyle(font: ttf)),
                    pw.Text("رقم الحساب: ${printingCashinHeadModel.accId}",
                        style: pw.TextStyle(font: ttf)),
                    pw.SizedBox(height: 12),
                    pw.Text(
                        "التاريخ: ${c.DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                        style: pw.TextStyle(font: ttf)),
                    pw.SizedBox(height: 24),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('الاجمالي:',
                            style: pw.TextStyle(font: ttf, fontSize: 14)),
                        pw.Text("${printingCashinHeadModel.total}",
                            style: pw.TextStyle(font: ttf, fontSize: 14)),
                      ],
                    ),
                    pw.SizedBox(height: 12),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('البيان:',
                            style: pw.TextStyle(font: ttf, fontSize: 14)),
                        pw.Text("${printingCashinHeadModel.descr}",
                            style: pw.TextStyle(font: ttf, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );

        final outputDir = await getTemporaryDirectory();
        final pdfFile = File("${outputDir.path}/cashin.pdf");
        await pdfFile.writeAsBytes(await pdf.save());

        await Share.shareXFiles([XFile(pdfFile.path)], text: 'سند قبض');
      } catch (e) {
        debugPrint("Error building or sharing PDF: $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "مشاركة سند القبض النقدي",
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: RepaintBoundary(
            key: _globalKey,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInfoRow("العميل:", printingCashinHeadModel.clint),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                          "رقم الحساب:", printingCashinHeadModel.accId),
                      const Divider(height: 32, thickness: 1.5),
                      _buildInfoRow("التاريخ:",
                          intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
                      const SizedBox(height: 24),
                      _buildInfoRow(
                          "الاجمالي:", "${printingCashinHeadModel.total}"),
                      const SizedBox(height: 16),
                      _buildInfoRow("البيان:", printingCashinHeadModel.descr),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomButton(
                onPressed: captureAndSharePdf,
                text: "مشاركة السند",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
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
                text: "الذهاب للرئيسية",
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInfoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Almarai',
            ),
          ),
          Flexible(
            child: Text(
              value?.toString() ?? '',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, fontFamily: 'Almarai'),
            ),
          ),
        ],
      ),
    );
  }
}
