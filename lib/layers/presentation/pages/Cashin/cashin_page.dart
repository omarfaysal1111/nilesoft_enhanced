import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/customers_dropdown.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_state.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nilesoft_erp/layers/presentation/pages/share_document/share_cashin.dart';
import 'package:uuid/uuid.dart';

CustomersModel? _customersModel;
final TextEditingController desc = TextEditingController();
final TextEditingController amount = TextEditingController();
String docNo = "";
bool isEditting = false;
List<CustomersModel>? customers;
CustomersModel? selected;
int id = 0;
int mysent = 0;

class CashinPage extends StatefulWidget {
  const CashinPage({super.key});

  @override
  State<CashinPage> createState() => _CashinPageState();
}

class _CashinPageState extends State<CashinPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clear();
  }

  void clear() {
    setState(() {
      desc.text = "";
      amount.text = "";
      docNo = "";
      isEditting = false;
      customers = [];
      id = -1;
    });
  }

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
                        mysent = state.cashinModel.sent!;
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
                        // Navigator.pop(context);
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
                        // Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is CashinInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CashinLoadedState) {
                        docNo = state.docNo!;
                        customers = state.customers;
                        return SearchableDropdown(
                          customers: state.customers,
                          selectedCustomer: state.selectedCustomer,
                          onCustomerSelected: mysent == 1
                              ? (va) {}
                              : (val) {
                                  if (val != null) {
                                    selected = val;
                                    _customersModel = val;
                                    bloc.add(CustomerSelectedCashEvent(
                                        selectedCustomer: val));
                                  }
                                },
                          width: MediaQuery.sizeOf(context).width,
                          onSearch: (v) {},
                        );
                      }

                      return SearchableDropdown(
                        customers: customers,
                        selectedCustomer: selected,
                        onCustomerSelected: mysent == 1
                            ? (va) {}
                            : (val) {
                                if (val != null) {
                                  selected = val;
                                  _customersModel = val;
                                  bloc.add(CustomerSelectedCashEvent(
                                      selectedCustomer: val));
                                }
                              },
                        width: MediaQuery.sizeOf(context).width,
                        onSearch: (v) {},
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "البيان",
                  controller: desc,
                  onChanged: (val) {},
                  readonly: mysent == 1 ? true : false,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "المبلغ",
                  controller: amount,
                  onChanged: (val) {},
                  readonly: mysent == 1 ? true : false,
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: "انهاء سند القبض النقدي",
                  onPressed: mysent == 1
                      ? () {
                          //  Navigator.pop(context);
                        }
                      : () {
                          if (mysent != 1) {
                            String formattedDate = intl.DateFormat('yyyy-MM-dd')
                                .format(DateTime.now());
                            var uuid = const Uuid();
                            String mobileUuid = uuid.v1().toString();

                            if (!isEditting) {
                              bloc.add(SaveCashinPressed(
                                cashinModel: CashinModel(
                                  accId: _customersModel!.id.toString(),
                                  descr: desc.text,
                                  docDate: formattedDate,
                                  mobileuuid: mobileUuid,
                                  docNo: docNo,
                                  sent: 0,
                                  clint: _customersModel!.name.toString(),
                                  total: double.parse(amount.text),
                                ),
                              ));
                            } else {
                              bloc.add(OnCashinUpdate(
                                cashinModel: CashinModel(
                                  accId: selected!.id.toString(),
                                  descr: desc.text,
                                  id: id,
                                  docDate: formattedDate,
                                  sent: mysent,
                                  docNo: docNo,
                                  mobileuuid: mobileUuid,
                                  clint: selected!.name.toString(),
                                  total: double.parse(amount.text),
                                ),
                              ));
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShareCashin(
                                        printingCashinHeadModel: CashinModel(
                                          accId: selected!.id.toString(),
                                          descr: desc.text,
                                          id: id,
                                          docDate: formattedDate,
                                          sent: mysent,
                                          docNo: docNo,
                                          mobileuuid: mobileUuid,
                                          clint: selected!.name.toString(),
                                          total: double.parse(amount.text),
                                        ),
                                        id: selected!.id.toString(),
                                        numOfSerials: 0))).then(
                              (value) {
                                setState(() {
                                  desc.clear();
                                  amount.clear();
                                  docNo = "";
                                  isEditting = false;
                                  customers = [];
                                  selected = null;
                                  _customersModel = null;
                                  id = 0;
                                  mysent = 0;
                                });
                              },
                            );
                          } else {
                            //  Navigator.pop(context);
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
