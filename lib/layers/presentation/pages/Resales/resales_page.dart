import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/info_card.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/components/summaray_card.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/Resales_popup/resales_popup.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_state.dart';
import 'package:intl/intl.dart' as intl;

class ResalesPage extends StatelessWidget {
  const ResalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResalesBloc()..add(ReInitializeDataEvent()),
      child: const ResalesPageContent(),
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

class ResalesPageContent extends StatelessWidget {
  const ResalesPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ResalesBloc>();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        total = 0;
        net = 0;
        dis = 0;
        tax = 0;
        dtl = [];
        isEditting = false;
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
                  "فاتورة مردودات مبيعات",
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
                    child: BlocConsumer<ResalesBloc, ResalesState>(
                      listener: (context, state) {
                        if (state is ResaleToEdit) {
                          dtl = state.salesDtlModel;
                          customers = state.customers;
                          selected = CustomersModel(
                              state.salesHeadModel.accid,
                              state.salesHeadModel.clientName,
                              state.salesHeadModel.invType);
                          isEditting = true;
                          final myDtl = state.salesDtlModel;
                          for (var i = 0; i < myDtl.length; i++) {
                            net = net +
                                ((myDtl[i].qty)! * (myDtl[i].price)! -
                                    (myDtl[i].disam)! +
                                    (myDtl[i].tax)!);
                            dis = dis + dtl![i].disam!;
                            tax = tax + dtl![i].tax!;
                            total = total + dtl![i].price!;
                          }
                        }
                        if (state is ResaleUpdateSucc) {
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
                        if (state is ReSaveSuccess) {
                          total = 0;
                          net = 0;
                          dis = 0;
                          tax = 0;
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("تم حفظ الفاتورة"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is ResalesInitial) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is ResalesError) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          );
                        } else if (state is ResalesPageLoaded) {
                          customers = state.customers;
                          headid = state.id!;
                          docNo = state.docNo.toString();
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
                                selected = CustomersModel("id", value, "type");
                                bloc.add(ReCustomerSelectedEvent(
                                    selectedCustomer:
                                        CustomersModel("id", value, "type")));
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "اختر العميل",
                              labelStyle:
                                  const TextStyle(fontFamily: 'Almarai'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 1),
                              ),
                            ),
                          );
                        }
                        return DropdownButtonFormField<String>(
                          value: selected?.name,
                          items: customers?.map((client) {
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
                              }).toList() ??
                              [],
                          onChanged: (value) {
                            if (value != null) {
                              selected = CustomersModel("id", value, "type");
                              bloc.add(ReCustomerSelectedEvent(
                                  selectedCustomer:
                                      CustomersModel("id", value, "type")));
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "اختر العميل",
                            labelStyle: const TextStyle(fontFamily: 'Almarai'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
                            ),
                          ),
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
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      child: CustomButton(
                        color: Colors.black87,
                        text: "حفظ الفاتورة",
                        onPressed: () {
                          if (!isEditting) {
                            if (selected == null) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("برجاء اضافة صنف واحد علي الاقل"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              });
                            } else {
                              String formattedDate =
                                  intl.DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now());
                              SalesHeadModel salesHeadModel = SalesHeadModel(
                                accid: selected!.id,
                                dis1: dis,
                                invoiceno: docNo,
                                sent: 0,
                                net: net,
                                docDate: formattedDate,
                                tax: tax,
                                total: total,
                                clientName: selected!.name,
                                descr: desc.text,
                              );

                              bloc.add(ReSaveButtonClicked(
                                  salesHeadModel: salesHeadModel,
                                  salesDtlModel: dtl!));
                            }
                          } else {
                            if (selected == null) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("برجاء اضافة صنف واحد علي الاقل"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              });
                            } else {
                              String formattedDate =
                                  intl.DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now());
                              SalesHeadModel salesHeadModel = SalesHeadModel(
                                accid: selected!.id,
                                dis1: dis,
                                invoiceno: docNo,
                                sent: 0,
                                id: int.parse(dtl![0].id.toString()),
                                net: net,
                                docDate: formattedDate,
                                tax: tax,
                                total: total,
                                clientName: selected!.name,
                                descr: desc.text,
                              );

                              bloc.add(OnUpdateResale(
                                  headModel: salesHeadModel, dtlModel: dtl!));
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: width * 0.4,
                      child: CustomButton(
                        text: "اضافة صنف",
                        onPressed: () {
                          bloc.add(ReFetchClientsEvent());
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return BlocProvider.value(
                                  value: BlocProvider.of<ResalesBloc>(context),
                                  child: AddnewPopup(
                                    id: headid,
                                    isEdit: false,
                                  ),
                                );
                              },
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Expanded(
                  child: BlocConsumer<ResalesBloc, ResalesState>(
                    listener: (context, state) {
                      if (state is ResalesEdittedState) {
                        dtl?[state.index] = state.editedItem;
                        bloc.add(ResalesPageLoded());
                      }
                      if (state is ResalesInitial) {
                        dtl = [];
                      }

                      if (state is AddNewResalesState) {
                        final myDtl = state.chosenItems;
                        total = 0;
                        net = 0;
                        dis = 0;
                        tax = 0;
                        for (var i = 0; i < myDtl.length; i++) {
                          net = net +
                              ((myDtl[i].qty)! * (myDtl[i].price)! -
                                  (myDtl[i].disam)! +
                                  (myDtl[i].tax)!);
                          dis = dis + myDtl[i].disam!;
                          tax = tax + myDtl[i].tax!;
                          total = total + myDtl[i].price!;
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is AddNewResalesState) {
                        final chosenClients = state.chosenItems;
                        dtl = chosenClients;

                        if (chosenClients.isEmpty) {
                          return const Center(child: Text("جاري اضافة الصنف"));
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 140.0),
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
                                total:
                                    ((dtl![index].qty)! * (dtl![index].price)! -
                                            (dtl![index].disam)! +
                                            (dtl![index].tax)!)
                                        .toString(),
                                onDelete: () {
                                  // Implement deletion logic
                                },
                                onEdit: () {
                                  editindex = index;
                                  bloc.add(ReEditPressed(
                                      salesDtlModel: dtl![index],
                                      index: index));
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return BlocProvider.value(
                                          value: BlocProvider.of<ResalesBloc>(
                                              context),
                                          child: AddnewPopup(
                                            isEdit: true,
                                            id: headid,
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
                      } else if (state is ResalesLoaded) {
                        Padding(
                          padding: const EdgeInsets.only(bottom: 140.0),
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
                                total:
                                    ((dtl![index].qty)! * (dtl![index].price)! -
                                            (dtl![index].disam)! +
                                            (dtl![index].tax)!)
                                        .toString(),
                                onDelete: () {
                                  // Implement deletion logic
                                },
                                onEdit: () {
                                  // bloc.add(EditPressed(
                                  //     salesDtlModel: chosenClients[index],
                                  //     index: index));
                                  editindex = index;
                                  bloc.add(ReEditPressed(
                                      salesDtlModel: dtl![index],
                                      index: index));
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return BlocProvider.value(
                                          value: BlocProvider.of<ResalesBloc>(
                                              context),
                                          child: AddnewPopup(
                                            isEdit: true,
                                            id: headid,
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
                              padding: const EdgeInsets.only(bottom: 140.0),
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
                                                (dtl![index].price)! -
                                            (dtl![index].disam)! +
                                            (dtl![index].tax)!)
                                        .toString(),
                                    onDelete: () {
                                      // Implement deletion logic
                                    },
                                    onEdit: () {
                                      // bloc.add(EditPressed(
                                      //     salesDtlModel: chosenClients[index],
                                      //     index: index));
                                      editindex = index;
                                      editindex = index;
                                      bloc.add(ReEditPressed(
                                          salesDtlModel: dtl![index],
                                          index: index));
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return BlocProvider.value(
                                              value:
                                                  BlocProvider.of<ResalesBloc>(
                                                      context),
                                              child: AddnewPopup(
                                                  isEdit: true, id: headid),
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
            Positioned(
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
                  discount: dis.toString(),
                  tax: tax.toString(),
                  net: net.toString(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
