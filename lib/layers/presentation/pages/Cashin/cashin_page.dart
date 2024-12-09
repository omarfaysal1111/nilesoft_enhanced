import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_state.dart';

CustomersModel? _customersModel;
final TextEditingController desc = TextEditingController();
final TextEditingController amount = TextEditingController();

class CashinPage extends StatelessWidget {
  const CashinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CashinBloc>();
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
                "سند قبض نقدي",
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
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: BlocConsumer<CashinBloc, CashinState>(
                  listener: (context, state) {
                    if (state is CashInSavedSuccessfuly) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم حفظ سند القبض النقدي"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is CashinInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CashinLoadedState) {
                      return DropdownButtonFormField<String>(
                        value: state.selectedCustomer?.name,
                        items: state.customers.map((client) {
                          return DropdownMenuItem<String>(
                            value: client.name,
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                client.name!,
                                overflow: TextOverflow
                                    .ellipsis, // Prevents text overflow
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _customersModel =
                                CustomersModel("id", value, "type");
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: "اختر العميل",
                          border: OutlineInputBorder(),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                  hintText: "البيان", controller: desc, onChanged: (val) {}),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                  hintText: "المبلغ", controller: amount, onChanged: (val) {}),
              const SizedBox(
                height: 40,
              ),
              CustomButton(
                  text: "انهاء سند القبض النقدي",
                  onPressed: () {
                    bloc.add(SaveCashinPressed(
                        cashinModel: CashinModel(
                            accId: _customersModel!.id.toString(),
                            descr: desc.text,
                            docDate: DateTime.now().toString(),
                            docNo: "",
                            total: double.parse(amount.text))));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
