import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/invoice_info.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/resales_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_state.dart';

class ReSalesPreviewPage extends StatelessWidget {
  const ReSalesPreviewPage({super.key});

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
                "استعراض مردودات المبيعات",
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
      body: BlocConsumer<RePreviewBloc, RePreviewState>(
        listener: (BuildContext context, RePreviewState state) {},
        builder: (BuildContext context, RePreviewState state) {
          if (state is ReDocPreviewInitial) {
            return const Text(
              "جاري التحميل",
              style:
                  TextStyle(fontFamily: 'Almarai', fontWeight: FontWeight.w700),
            );
          }
          if (state is ReDocPreviewLoaded) {
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
                                create: (context) => ResalesBloc()
                                  ..add(OnResaleToEdit(
                                      state.salesModel[index].id!)),
                                child: const ResalesPageContent(),
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
