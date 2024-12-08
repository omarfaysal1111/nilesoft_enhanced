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
import 'package:nilesoft_erp/layers/presentation/pages/invoice/addnew_popup/addnew_popup.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_state.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage(
      {super.key, required this.extraTitle, required this.invoiceType});
  final String extraTitle;
  final int invoiceType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceBloc()..add(InitializeDataEvent()),
      child:
          InvoicePageContent(extraTitle: extraTitle, invoiceType: invoiceType),
    );
  }
}

List<ItemsModel> myClients = [];
List<CustomersModel>? customers;
List<SalesDtlModel>? dtl;
CustomersModel? selected;

class InvoicePageContent extends StatelessWidget {
  const InvoicePageContent(
      {super.key, required this.extraTitle, required this.invoiceType});
  final String extraTitle;
  final int invoiceType;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
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
                      if (state is SaveSuccess) {
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
                      if (state is InvoicePageInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is InvoiceError) {
                        return Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        );
                      } else if (state is InvoicePageLoaded) {
                        customers = state.customers;
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
                              bloc.add(CustomerSelectedEvent(
                                  selectedCustomer:
                                      CustomersModel("id", value, "type")));
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: "اختر العميل",
                            border: OutlineInputBorder(),
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
                            bloc.add(CustomerSelectedEvent(
                                selectedCustomer:
                                    CustomersModel("id", value, "type")));
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
              ),
              SizedBox(height: height * 0.02),
              SizedBox(
                  width: width * 0.9,
                  child: CustomTextField(
                    hintText: "البيان",
                    onChanged: (value) {},
                  )),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width * 0.4,
                    child: CustomButton(
                      text: "حفظ",
                      onPressed: () {
                        SalesHeadModel salesHeadModel = SalesHeadModel(
                          accid: selected!.id,
                          dis1: 1,
                          invoiceno: "",
                          sent: 0,
                          net: 1,
                          tax: 1,
                          total: 1,
                          clientName: selected!.name,
                          descr: "",
                        );

                        bloc.add(SaveButtonClicked(
                            salesHeadModel: salesHeadModel,
                            salesDtlModel: dtl!));
                      },
                    ),
                  ),
                  SizedBox(
                    width: width * 0.4,
                    child: CustomButton(
                      text: "اضافة",
                      onPressed: () {
                        bloc.add(FetchClientsEvent());
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return BlocProvider.value(
                                value: BlocProvider.of<InvoiceBloc>(context),
                                child: const AddnewPopup(),
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
                child: BlocBuilder<InvoiceBloc, InvoiceState>(
                  builder: (context, state) {
                    if (state is AddNewInvoiceState) {
                      final chosenClients = state.chosenItems;
                      dtl = chosenClients;
                      if (chosenClients.isEmpty) {
                        return const Center(child: Text("No chosen clients."));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 140.0),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: chosenClients.length,
                          itemBuilder: (context, index) {
                            return InfoCard(
                              title: chosenClients[index].itemName.toString(),
                              price: chosenClients[index].price.toString(),
                              discount: chosenClients[index].disam.toString(),
                              quantity: chosenClients[index].qty.toString(),
                              tax: chosenClients[index].tax.toString(),
                              total: ((chosenClients[index].qty)! *
                                          (chosenClients[index].price)! -
                                      (chosenClients[index].disam)! +
                                      (chosenClients[index].tax)!)
                                  .toString(),
                              onDelete: () {
                                // Implement deletion logic
                              },
                              onEdit: () {},
                            );
                          },
                        ),
                      );
                    }
                    return const Center(child: Text("No Clients Added"));
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
              child: const SummaryCard(
                total: "200",
                discount: "0",
                tax: "0",
                net: "200",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
