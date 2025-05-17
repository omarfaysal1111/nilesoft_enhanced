import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as c;
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

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future<void> captureAndSharePdf() async {
      try {
        RenderRepaintBoundary? boundary = _globalKey.currentContext
            ?.findRenderObject() as RenderRepaintBoundary?;

        if (boundary == null) {
          debugPrint("RenderRepaintBoundary is null");
          return;
        }

        final pixelRatio = MediaQuery.of(context).devicePixelRatio;
        final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
        final ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        final Uint8List pngBytes = byteData!.buffer.asUint8List();

        final pdf = pw.Document();
        final imageProvider = pw.MemoryImage(pngBytes);

        pdf.addPage(
          pw.Page(
            build: (context) => pw.Center(child: pw.Image(imageProvider)),
          ),
        );

        final outputDir = await getTemporaryDirectory();
        final pdfFile = File("${outputDir.path}/invoice.pdf");
        await pdfFile.writeAsBytes(await pdf.save());

        await Share.shareXFiles([XFile(pdfFile.path)], text: 'Invoice');
      } catch (e) {
        debugPrint("Error capturing or sharing PDF: $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            onPressed: () async => await captureAndSharePdf(),
            text: ("ارسال الفاتورة"),
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
            text: (" الي الرئيسية"),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              border: Border.all(color: Colors.black, width: 2)),
          child: Center(
            child: RepaintBoundary(
              key: _globalKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(printingSalesHeadModel.invoiceno.toString()),
                    Text(printingSalesHeadModel.clientName.toString()),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(c.DateFormat('yyyy-MM-dd').format(DateTime.now())),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Table(
                      border: TableBorder.all(),
                      children: _buildTableRows(),
                    ),
                    const SizedBox(height: 16),
                    Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'الاجمالي ',
                                      textAlign: TextAlign.right,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${printingSalesHeadModel.total}",
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'الضريبة',
                                      textAlign: TextAlign.right,
                                    ),
                                    Text(
                                      "${printingSalesHeadModel.tax}",
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'الخصم',
                                      textAlign: TextAlign.right,
                                    ),
                                    Text(
                                      "${printingSalesHeadModel.dis1}",
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'الخصم علي الفاتورة',
                                      textAlign: TextAlign.right,
                                    ),
                                    Text(
                                      "${printingSalesHeadModel.disratio}",
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'الصافي',
                                      textAlign: TextAlign.right,
                                    ),
                                    Text(
                                      "${printingSalesHeadModel.net}",
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    return [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('الصنف'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('الكمية'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('السعر'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('الخصم'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('الاجمالي'),
          ),
        ],
      ),
      ...printingSalesDtlModel.map(
        (item) => TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.itemName.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.qty.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.price.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.disam.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  (item.price! * double.parse(item.qty.toString())).toString()),
            ),
          ],
        ),
      ),
    ];
  }
}
