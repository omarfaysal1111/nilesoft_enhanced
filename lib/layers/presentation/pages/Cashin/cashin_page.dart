import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_state.dart';
import 'package:intl/intl.dart' as intl;

CustomersModel? _customersModel;
final TextEditingController desc = TextEditingController();
final TextEditingController amount = TextEditingController();
String docNo = "";
bool isEditting = false;
List<CustomersModel>? customers;
CustomersModel? selected;
int id = 0;

class CashinPage extends StatelessWidget {
  const CashinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CashinBloc>();
    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        desc.text = "";
        amount.text = "";
        docNo = "";
        isEditting = false;
        customers = [];
        id = -1;
        //desc.dispose();
      },
      child: Scaffold(
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
                      if (state is CashInToEditState) {
                        customers = state.customers;
                        isEditting = true;
                        id = state.cashinModel.id!;
                        desc.text = state.cashinModel.descr.toString();
                        amount.text = state.cashinModel.total.toString();
                        selected = CustomersModel(state.cashinModel.accId,
                            state.cashinModel.clint, "1");
                      }
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
                      if (state is CashInUpdateSucc) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("تم تعديل سند القبض النقدي"),
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
                        docNo = state.docNo!;
                        customers = state.customers;
                        return DropdownButtonFormField<CustomersModel>(
                          value: state.selectedCustomer,
                          items: state.customers.map((client) {
                            return DropdownMenuItem<CustomersModel>(
                              value: client,
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
                              selected = value;
                              _customersModel = value;
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: "اختر العميل",
                            border: OutlineInputBorder(),
                          ),
                        );
                      }
                      return DropdownButtonFormField<CustomersModel>(
                        value: selected,
                        items: customers!.map((client) {
                          return DropdownMenuItem<CustomersModel>(
                            value: client,
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
                            _customersModel = value;
                            selected = _customersModel;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: "اختر العميل",
                          border: OutlineInputBorder(),
                        ),
                      );
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
                    hintText: "المبلغ",
                    controller: amount,
                    onChanged: (val) {}),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                    text: "انهاء سند القبض النقدي",
                    onPressed: () {
                      String formattedDate =
                          intl.DateFormat('dd-MM-yyyy').format(DateTime.now());
                      if (!isEditting) {
                        bloc.add(SaveCashinPressed(
                            cashinModel: CashinModel(
                                accId: _customersModel!.id.toString(),
                                descr: desc.text,
                                docDate: formattedDate,
                                docNo: docNo,
                                clint: _customersModel!.name.toString(),
                                total: double.parse(amount.text))));
                      } else {
                        bloc.add(OnCashinUpdate(
                            cashinModel: CashinModel(
                                accId: selected!.id.toString(),
                                descr: desc.text,
                                id: id,
                                docDate: formattedDate,
                                docNo: docNo,
                                clint: selected!.name.toString(),
                                total: double.parse(amount.text))));
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
