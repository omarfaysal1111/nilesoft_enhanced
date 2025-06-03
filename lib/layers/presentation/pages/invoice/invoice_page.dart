import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/customers_dropdown.dart';
import 'package:nilesoft_erp/layers/presentation/components/info_card.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/components/summaray_card.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/addnew_popup/addnew_popup.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_state.dart';
import 'package:nilesoft_erp/layers/presentation/pages/serials/bloc/serial_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/serials/bloc/serials_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/serials/serials_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/share_document/share_screen.dart';
import 'package:uuid/uuid.dart';

final disamController = TextEditingController();
final disratController = TextEditingController();

class InvoicePage extends StatelessWidget {
  const InvoicePage(
      {super.key, required this.extraTitle, required this.invoiceType});
  final String extraTitle;
  final int invoiceType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceBloc()..add(InitializeDataEvent()),
      child: InvoicePageContent(
        extraTitle: extraTitle,
        invoiceType: invoiceType,
        sent: 0,
      ),
    );
  }
}

final TextEditingController desc = TextEditingController();

List<ItemsModel> myClients = [];
List<CustomersModel>? customers;
List<SalesDtlModel>? dtl;
CustomersModel? selected;
int editindex = -1;
double total = 0;
double dis = 0;
double tax = 0;
double net = 0;
int headid = 0;
String docNo = "";
bool isEditting = false;
String selectedValue = '1';

class InvoicePageContent extends StatelessWidget {
  const InvoicePageContent(
      {super.key,
      required this.extraTitle,
      required this.invoiceType,
      required this.sent});
  final String extraTitle;
  final int invoiceType;
  final int sent;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        total = 0;
        net = 0;
        dis = 0;
        customers = [];
        selected = null;
        desc.text = "";
        tax = 0;
        disamController.text = "";
        disratController.text = "";
        dtl = [];
        customers = [];
        isEditting = false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "فاتورة $extraTitle",
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: height * 0.02),
                SizedBox(
                  width: width * 0.9,
                  height: 57,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: BlocConsumer<InvoiceBloc, InvoiceState>(
                      listener: (context, state) {
                        if (state is InvoiceInitial) {
                          total = 0;
                          net = 0;
                          dis = 0;
                          customers = [];
                          selected = null;
                          desc.text = "";
                          tax = 0;
                          disamController.text = "";
                          disratController.text = "";
                          dtl = [];
                          customers = [];
                          isEditting = false;

                          total = 0;
                          net = 0;
                          dis = 0;
                          tax = 0;
                        }
                        if (state is CheckBoxSelected) {
                          selectedValue = state.value;
                        }
                        if (state is HasSerialState) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => SerialsBloc()
                                  ..add(OnSerialInit(
                                      invId: headid.toString(),
                                      lenOfSerials: state.len)),
                                child: const SerialsPage(),
                              ),
                            ),
                          );
                        }
                        if (state is InvoiceToEdit) {
                          dtl = state.salesDtlModel;
                          headid = state.salesHeadModel.id ?? 0;
                          isEditting = true;
                          customers = state.customers;
                          disamController.text =
                              state.salesHeadModel.disam.toString();
                          disratController.text =
                              state.salesHeadModel.disratio.toString();
                          selected = CustomersModel(
                              state.salesHeadModel.accid,
                              state.salesHeadModel.clientName,
                              state.salesHeadModel.invType);
                          final myDtl = state.salesDtlModel;
                          for (var i = 0; i < myDtl.length; i++) {
                            dis = dis + dtl![i].disam! * dtl![i].qty!;
                            tax = tax + dtl![i].tax! * dtl![i].qty!;
                            total = total + dtl![i].price! * dtl![i].qty!;
                            net = total - dis + tax;
                          }
                        }
                        if (state is SaveSuccess) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("تم حفظ الفاتورة"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          });
                          var uuid = const Uuid();
                          String mobileUuid = uuid.v1().toString();
                          String formattedDate = intl.DateFormat('yyyy-MM-dd')
                              .format(DateTime.now());
                          SalesHeadModel salesHeadModel = SalesHeadModel(
                            accid: selected!.id,
                            dis1: dis,
                            invoiceno: docNo,
                            invType: selectedValue,
                            sent: 0,
                            disam: double.tryParse(disamController.text) ?? 0,
                            disratio:
                                double.tryParse(disratController.text) ?? 0,
                            net: net,
                            docDate: formattedDate,
                            mobile_uuid: mobileUuid,
                            tax: tax,
                            total: total,
                            clientName: selected!.name,
                            descr: desc.text,
                          );

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrintingScreen(
                                    printingSalesDtlModel: dtl!,
                                    printingSalesHeadModel: salesHeadModel,
                                    id: salesHeadModel.accid.toString(),
                                    numOfSerials: 0),
                              )).then((o) {
                            total = 0;
                            net = 0;
                            dis = 0;
                            customers = [];
                            selected = null;
                            desc.text = "";
                            tax = 0;
                            disamController.text = "";
                            disratController.text = "";
                            dtl = [];
                            customers = [];
                            isEditting = false;
                          });
                          total = 0;
                          net = 0;
                          dis = 0;
                          tax = 0;
                        }
                        if (state is UpdateSucc) {
                          total = 0;
                          net = 0;
                          dis = 0;
                          tax = 0;
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("تم تعديل الفاتورة"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is InvoiceInitial) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is InvoiceError) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          );
                        } else if (state is InvoicePageLoaded) {
                          docNo = state.docNo.toString();
                          customers = state.customers;
                          headid = state.id!;
                          return SearchableDropdown(
                            onSearch: (val) {},
                            customers: customers, // Pass the list of customers
                            selectedCustomer: selected, // The current selection
                            onCustomerSelected: (value) {
                              if (value != null) {
                                selected = value;
                                bloc.add(CustomerSelectedEvent(
                                    selectedCustomer: value));
                              }
                            },
                            width: width, // Pass the width for layout
                          );
                        }
                        return Column(
                          children: [
                            SearchableDropdown(
                              onSearch: (val) {},
                              customers:
                                  customers, // Pass the list of customers
                              selectedCustomer:
                                  selected, // The current selection
                              onCustomerSelected: (value) {
                                if (value != null) {
                                  selected = value;
                                  bloc.add(CustomerSelectedEvent(
                                      selectedCustomer: value));
                                }
                              },
                              width: width, // Pass the width for layout
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                    width: width * 0.9,
                    child: CustomTextField(
                      hintText: "البيان",
                      controller: desc,
                      onChanged: (value) {},
                    )),
                BlocConsumer<InvoiceBloc, InvoiceState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text('اجل'),
                              Radio<String>(
                                value: '1',
                                groupValue: selectedValue,
                                onChanged: (String? value) {
                                  bloc.add(OnSelectCheckBox(value: value!));
                                },
                              ),
                            ],
                          ),
                          const Text('نقدي'),
                          Radio<String>(
                            value: '0',
                            groupValue: selectedValue,
                            onChanged: (String? value) {
                              bloc.add(OnSelectCheckBox(value: value!));
                            },
                          ),
                        ],
                      );
                    }),
                SizedBox(height: height * 0.002),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      child: sent == 0
                          ? CustomButton(
                              color: Colors.black87,
                              text: "حفظ الفاتورة",
                              onPressed: () {
                                if (!isEditting) {
                                  if (selected == null) {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("برجاء اختيار العميل"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    });
                                  } else if (dtl == [] ||
                                      dtl == null ||
                                      dtl!.isEmpty) {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "برجاء اضافة صنف واحد علي الاقل"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    });
                                  } else {
                                    var uuid = const Uuid();

                                    // ignore: non_constant_identifier_names
                                    String mobile_uuid = uuid.v1().toString();
                                    String formattedDate =
                                        intl.DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now());
                                    SalesHeadModel salesHeadModel =
                                        SalesHeadModel(
                                      accid: selected!.id,
                                      dis1: dis,
                                      invoiceno: docNo,
                                      sent: 0,
                                      disam: double.parse(disamController.text),
                                      disratio: double.tryParse(
                                              disratController.text) ??
                                          0,
                                      net: net,
                                      docDate: formattedDate,
                                      invType: selectedValue,
                                      mobile_uuid: mobile_uuid,
                                      tax: tax,
                                      total: total,
                                      clientName: selected!.name,
                                      descr: desc.text,
                                    );

                                    bloc.add(SaveButtonClicked(
                                        salesHeadModel: salesHeadModel,
                                        salesDtlModel: dtl!));
                                  }
                                } else {
                                  if (selected == null) {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("برجاء اختيار العميل"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    });
                                  } else if (dtl == [] ||
                                      dtl == null ||
                                      dtl!.isEmpty) {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "برجاء اضافة صنف واحد علي الاقل"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    });
                                  } else {
                                    var uuid = const Uuid();

                                    // ignore: non_constant_identifier_names
                                    String mobile_uuid = uuid.v1().toString();
                                    String formattedDate =
                                        intl.DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now());

                                    SalesHeadModel salesHeadModel =
                                        SalesHeadModel(
                                      id: headid,
                                      accid: selected!.id,
                                      dis1: dis,
                                      invoiceno: docNo,
                                      sent: 0,
                                      disam: double.parse(disamController.text),
                                      disratio: double.tryParse(
                                              disratController.text) ??
                                          0,
                                      net: net,
                                      docDate: formattedDate,
                                      invType: selectedValue,
                                      mobile_uuid: mobile_uuid,
                                      tax: tax,
                                      total: total,
                                      clientName: selected!.name,
                                      descr: desc.text,
                                    );

                                    bloc.add(OnUpdateInvoice(
                                        headModel: salesHeadModel,
                                        dtlModel: dtl ?? []));
                                  }
                                }
                              },
                            )
                          : const SizedBox(),
                    ),
                    SizedBox(
                      width: width * 0.4,
                      child: sent == 0
                          ? CustomButton(
                              text: "اضافة صنف",
                              onPressed: () {
                                bloc.add(FetchClientsEvent());
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return BlocProvider.value(
                                        value: BlocProvider.of<InvoiceBloc>(
                                            context),
                                        child: AddnewPopup(
                                          isEdit: false,
                                          headId: headid,
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Expanded(
                  child: BlocConsumer<InvoiceBloc, InvoiceState>(
                    listener: (context, state) {
                      if (state is CardDeleted) {
                        dtl = dtl;
                      }
                      if (state is InvoiceEdittedState) {
                        dtl?[state.index] = state.editedItem;
                        bloc.add(InvoicePageLoded());
                      }
                      if (state is InvoiceInitial) {
                        dtl = [];
                      }

                      if (state is AddNewInvoiceState) {
                        final myDtl = state.chosenItems;
                        // Reset all values before recalculating
                        total = 0;
                        net = 0;
                        dis = 0;
                        tax = 0;

                        // Calculate totals from items
                        for (var item in myDtl) {
                          // Calculate item total before discount
                          double itemTotal =
                              (item.qty ?? 0) * (item.price ?? 0);
                          // Add to running total
                          total += itemTotal;

                          // Add discounts and tax
                          dis += (item.disam! * item.qty!);
                          tax += item.tax! * item.qty! * item.price! / 100;
                        }

                        // Calculate final net amount
                        net = total - dis + tax;

                        // Update discount amount based on rate
                        double discountRate =
                            double.tryParse(disratController.text) ?? 0;
                        double discountAmount = (discountRate / 100) * total;
                        disamController.text =
                            discountAmount.toStringAsFixed(2);
                      }
                      if (disamController.text == "0") {
                        disratController.text = "0";
                      }
                    },
                    builder: (context, state) {
                      if (state is AddNewInvoiceState) {
                        final chosenClients = state.chosenItems;
                        if (!isEditting) {
                          dtl = chosenClients;
                        } else {
                          dtl![editindex] = chosenClients[0].clone();
                        }
                        if (chosenClients.isEmpty) {
                          return const Center(child: Text("جاري اضافة الصنف"));
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 220.0),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: dtl?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InfoCard(
                                title: dtl![index].itemName.toString(),
                                price: dtl![index].price.toString(),
                                discount: dtl![index].disam.toString(),
                                quantity: dtl![index].qty.toString(),
                                tax: dtl![index].tax.toString(),
                                total: (dtl![index].price! * dtl![index].qty!)
                                    .toString(),
                                onDelete: () {
                                  dtl!.removeAt(index);
                                  total = 0;
                                  net = 0;
                                  dis = 0;
                                  tax = 0;

                                  // Calculate totals from items
                                  for (var item in dtl!) {
                                    // Calculate item total before discount
                                    double itemTotal =
                                        (item.qty ?? 0) * (item.price ?? 0);
                                    // Add to running total
                                    total += itemTotal;

                                    // Add discounts and tax
                                    dis += (item.disam! * item.qty!);
                                    tax += item.tax! *
                                        item.qty! *
                                        item.price! /
                                        100;
                                  }

                                  // Calculate final net amount
                                  net = total - dis + tax;
                                  bloc.add(OnDeleteCard());
                                },
                                onEdit: () {
                                  editindex = index;
                                  bloc.add(EditPressed(
                                    salesDtlModel:
                                        dtl![index].clone(), // pass a copy
                                    index: index,
                                  ));
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return BlocProvider.value(
                                          value: BlocProvider.of<InvoiceBloc>(
                                              context),
                                          child: AddnewPopup(
                                            isEdit: true,
                                            headId: headid,
                                            toEdit: dtl?[index],
                                          ),
                                        );
                                      },
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        );
                      } else if (state is InvoiceLoaded) {
                        Padding(
                          padding: const EdgeInsets.only(bottom: 220.0),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: dtl?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InfoCard(
                                title: dtl![index].itemName.toString(),
                                price: dtl![index].price.toString(),
                                discount: dtl![index].disam.toString(),
                                quantity: dtl![index].qty.toString(),
                                tax: dtl![index].tax.toString(),
                                total: (dtl![index].price! * dtl![index].qty!)
                                    .toString(),
                                onDelete: () {
                                  dtl!.removeAt(index);
                                  total = 0;
                                  net = 0;
                                  dis = 0;
                                  tax = 0;

                                  // Calculate totals from items
                                  for (var item in dtl!) {
                                    // Calculate item total before discount
                                    double itemTotal =
                                        (item.qty ?? 0) * (item.price ?? 0);
                                    // Add to running total
                                    total += itemTotal;

                                    // Add discounts and tax
                                    dis += (item.disam! * item.qty!);
                                    tax += item.tax! *
                                        item.qty! *
                                        item.price! /
                                        100;
                                  }

                                  // Calculate final net amount
                                  net = total - dis + tax;
                                  bloc.add(OnDeleteCard());
                                },
                                onEdit: () {
                                  // bloc.add(EditPressed(
                                  //     salesDtlModel: chosenClients[index],
                                  //     index: index));
                                  editindex = index;
                                  bloc.add(EditPressed(
                                    salesDtlModel:
                                        dtl![index].clone(), // pass a copy
                                    index: index,
                                  ));
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return BlocProvider.value(
                                          value: BlocProvider.of<InvoiceBloc>(
                                              context),
                                          child: AddnewPopup(
                                            isEdit: true,
                                            headId: headid,
                                          ),
                                        );
                                      },
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        );
                      }
                      // ignore: prefer_is_empty
                      return dtl == null || dtl?.length == 0
                          ? const Column(
                              children: [
                                Icon(
                                  Icons.arrow_outward_rounded,
                                  applyTextScaling: true,
                                  weight: 900,
                                  size: 72,
                                  color: Color.fromARGB(255, 91, 89, 89),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    "قم بإضافة الاصناف الي الفاتورة",
                                    style: TextStyle(
                                        fontFamily: 'Almarai',
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromARGB(255, 91, 89, 89),
                                        fontSize: 22),
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 220.0),
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: dtl?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return InfoCard(
                                    title: dtl![index].itemName.toString(),
                                    price: dtl![index].price.toString(),
                                    discount: dtl![index].disam.toString(),
                                    quantity: dtl![index].qty.toString(),
                                    tax: dtl![index].tax.toString(),
                                    total: ((dtl![index].qty)! *
                                            (dtl![index].price)!)
                                        .toString(),
                                    onDelete: () {
                                      dtl!.removeAt(index);
                                      total = 0;
                                      net = 0;
                                      dis = 0;
                                      tax = 0;

                                      // Calculate totals from items
                                      for (var item in dtl!) {
                                        // Calculate item total before discount
                                        double itemTotal =
                                            (item.qty ?? 0) * (item.price ?? 0);
                                        // Add to running total
                                        total += itemTotal;

                                        // Add discounts and tax
                                        dis += (item.disam! * item.qty!);
                                        tax += item.tax! *
                                            item.qty! *
                                            item.price! /
                                            100;
                                      }

                                      // Calculate final net amount
                                      net = total - dis + tax;
                                      bloc.add(OnDeleteCard());
                                    },
                                    onEdit: () {
                                      // bloc.add(EditPressed(
                                      //     salesDtlModel: chosenClients[index],
                                      //     index: index));
                                      // editindex = index;
                                      editindex = index;
                                      bloc.add(EditPressed(
                                        salesDtlModel:
                                            dtl![index].clone(), // pass a copy
                                        index: index,
                                      ));
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return BlocProvider.value(
                                              value:
                                                  BlocProvider.of<InvoiceBloc>(
                                                      context),
                                              child: AddnewPopup(
                                                isEdit: true,
                                                headId: headid,
                                              ),
                                            );
                                          },
                                        );
                                      });
                                    },
                                  );
                                },
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
            BlocConsumer<InvoiceBloc, InvoiceState>(listener: (context, state) {
              if (state is DisamChanged) {
                net = (total + tax) - dis - state.amValue;
                disratController.text =
                    state.ratValue.toStringAsFixed(1).toString();
                disamController.text =
                    (state.amValue.toStringAsFixed(1)).toString();
              }

              if (state is DisratChanged) {
                net = (total + tax) - dis - state.amValue;
                // net = state.net;
                disratController.text =
                    state.ratValue.toStringAsFixed(1).toString();
                disamController.text =
                    (state.amValue.toStringAsFixed(1)).toString();
              }
            }, builder: (context, state) {
              if (state is InvoiceToEdit) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: Color(0xff39B3BD),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: SummaryCard(
                      total: total.toString(),
                      disamController: disamController,
                      disratController: disratController,
                      discount: dis.toString(),
                      tax: tax.toString(),
                      net: net.toString(),
                      amChanged: (String value) {
                        double amValue = double.tryParse(value) ?? 0;
                        net = total - amValue + tax;
                        bloc.add(
                            OnDisamChanged(total, dis, net, value: amValue));
                      },
                      ratChanged: (String value) {
                        double ratValue = double.tryParse(value) ?? 0;
                        double amValue = (ratValue / 100) * total;
                        net = total - amValue + tax;
                        bloc.add(
                            OnDisratChanged(total, dis, net, value: ratValue));
                      },
                    ),
                  ),
                );
              }
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Color(0xff39B3BD),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: SummaryCard(
                    total: total.toString(),
                    disamController: disamController,
                    disratController: disratController,
                    discount: dis.toString(),
                    tax: (tax).toString(),
                    net: net.toString(), // Show net amount // Show total amount
                    amChanged: (String value) {
                      double amValue = double.tryParse(value) ?? 0;
                      // Calculate net: total - discount + tax
                      net = total - amValue + tax;
                      bloc.add(OnDisamChanged(total, dis, net, value: amValue));
                    },
                    ratChanged: (String value) {
                      double ratValue = double.tryParse(value) ?? 0;
                      // Calculate discount amount from rate
                      double amValue = (ratValue / 100) * total;
                      // Calculate net: total - discount + tax
                      net = total - amValue + tax;
                      bloc.add(
                          OnDisratChanged(total, dis, net, value: ratValue));
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
