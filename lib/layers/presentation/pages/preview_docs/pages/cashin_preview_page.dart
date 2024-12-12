import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/invoice_info.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/cashin_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_state.dart';

class CashinPreviewPage extends StatelessWidget {
  const CashinPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<CashinPrevBloc, CashinPrevState>(
        listener: (BuildContext context, CashinPrevState state) {},
        builder: (BuildContext context, CashinPrevState state) {
          if (state is CashinPrevInit) {
            return const Text(
              "جاري التحميل",
              style:
                  TextStyle(fontFamily: 'Almarai', fontWeight: FontWeight.w700),
            );
          }
          if (state is CashInPrevLoaded) {
            return ListView.builder(
                itemCount: state.cashinModel.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DocInfoCard(
                        customerName: state.cashinModel[index].clint.toString(),
                        dateValue: state.cashinModel[index].docDate.toString(),
                        netValue: state.cashinModel[index].net1 ?? 0,
                        docNumber: state.cashinModel[index].docNo.toString(),
                        onViewPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => CashinBloc()
                                    ..add(OnCashinToEdit(
                                        cashinModel: state.cashinModel[index],
                                        id: state.cashinModel[index].id!)),
                                  child: const CashinPage(),
                                ),
                              ));
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
