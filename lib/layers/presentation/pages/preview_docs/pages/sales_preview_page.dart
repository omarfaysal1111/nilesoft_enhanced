import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/invoice_info.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/invoice_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/preview_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/preview_state.dart';

class SalesPreviewPage extends StatelessWidget {
  const SalesPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                "استعراض فواتير المبيعات",
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
      body: BlocConsumer<PreviewBloc, PreviewState>(
        listener: (BuildContext context, PreviewState state) {},
        builder: (BuildContext context, PreviewState state) {
          if (state is DocPreviewInitial) {
            return const Text(
              "جاري التحميل",
              style:
                  TextStyle(fontFamily: 'Almarai', fontWeight: FontWeight.w700),
            );
          }
          if (state is DocPreviewLoaded) {
            return ListView.builder(
                itemCount: state.salesModel.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DocInfoCard(
                        customerName:
                            state.salesModel[index].clientName.toString(),
                        dateValue: state.salesModel[index].docDate.toString(),
                        netValue: state.salesModel[index].net ?? 0,
                        docNumber: state.salesModel[index].invoiceno.toString(),
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => InvoiceBloc()
                                  ..add(OnInvoiceToEdit(
                                      state.salesModel[index].id!)),
                                child: const InvoicePageContent(
                                  extraTitle: "المبيعات",
                                  invoiceType: 0,
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                });
          }
          return const Text("data");
        },
      ),
    );
  }
}
