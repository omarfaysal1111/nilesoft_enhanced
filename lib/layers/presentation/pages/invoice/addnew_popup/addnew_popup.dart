import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_state.dart';

final priceControlleer = TextEditingController();
final disControlleer = TextEditingController();
final disRatioControlleer = TextEditingController();
final taxControlleer = TextEditingController();
final qtyControlleer = TextEditingController();
List<ItemsModel> myItems = [];
ItemsModel? selectedItem;

class AddnewPopup extends StatelessWidget {
  const AddnewPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();
    double width = MediaQuery.sizeOf(context).width;

    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (popped) {
        // Reset all controllers and variables
        priceControlleer.clear();
        disControlleer.clear();
        disRatioControlleer.clear();
        taxControlleer.clear();
        qtyControlleer.clear();
        selectedItem = null;
        myItems = [];
      },
      child: SizedBox(
        width: 450,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Dropdown for "اختر العميل"
              Directionality(
                textDirection: TextDirection.rtl,
                child: BlocConsumer<InvoiceBloc, InvoiceState>(
                  listener: (context, state) {
                    if (state is DiscountChanged) {
                      disControlleer.text = state.amount.toString();
                      disRatioControlleer.text = state.ratio.toString();
                    }
                    if (state is DiscountRatioChanged) {
                      disControlleer.text = state.amount.toString();
                      disRatioControlleer.text = state.ratio.toString();
                    }
                    if (state is EditState) {
                      selectedItem = selectedItem = ItemsModel(
                        "itemid",
                        state.salesDtlModel.itemName,
                        1,
                        12,
                        "barcode",
                        0,
                      );
                      //selectedItem!.name = state.salesDtlModel.itemName;
                      disControlleer.text =
                          state.salesDtlModel.disam.toString();
                      disRatioControlleer.text =
                          state.salesDtlModel.disratio.toString();
                      priceControlleer.text =
                          state.salesDtlModel.price.toString();
                      taxControlleer.text = state.salesDtlModel.tax.toString();
                      qtyControlleer.text = state.salesDtlModel.qty.toString();
                    }
                  },
                  builder: (context, state) {
                    if (state is InvoiceLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is InvoiceError) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (state is InvoiceLoaded) {
                      // Populate clients and reset values
                      myItems = state.clients;
                      final selectedValue = state.clients.any((client) =>
                              client.name == state.selectedClient?.name)
                          ? state.selectedClient?.name
                          : null;

                      return DropdownButtonFormField<String>(
                        value: selectedValue,
                        items: state.clients.map((client) {
                          return DropdownMenuItem<String>(
                            value: client.name,
                            child: Text(client.name!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedItem = ItemsModel(
                              "itemid",
                              value,
                              1,
                              12,
                              "barcode",
                              0,
                            );
                            bloc.add(ClientSelectedEvent(selectedItem!));
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: "اختر الصنف",
                          labelStyle: TextStyle(
                            fontFamily: 'Almarai',
                          ),
                          border: OutlineInputBorder(),
                        ),
                      );
                    }
                    // Fallback Dropdown
                    return DropdownButtonFormField<String>(
                      value: selectedItem?.name,
                      items: myItems.map((client) {
                        return DropdownMenuItem<String>(
                          value: client.name,
                          child: Text(client.name!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedItem = ItemsModel(
                            "itemid",
                            value,
                            1,
                            12,
                            "barcode",
                            0,
                          );
                          bloc.add(ClientSelectedEvent(selectedItem!));
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: "اختر الصنف",
                        labelStyle: TextStyle(
                          fontFamily: 'Almarai',
                        ),
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // TextFields for price, discount, quantity
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 100,
                          child: CustomTextField(
                            onChanged: (value) {},
                            hintText: "الكمية",
                            controller: qtyControlleer,
                          )),
                      SizedBox(
                          width: 100,
                          child: CustomTextField(
                            onChanged: (value) {},
                            hintText: "السعر",
                            controller: priceControlleer,
                          )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 100,
                          child: CustomTextField(
                            onChanged: (val) {
                              bloc.add(OnDiscountChanged(
                                double.parse(priceControlleer.text),
                                amount: double.parse(val),
                                ratio:
                                    double.tryParse(disRatioControlleer.text) ??
                                        0.0,
                              ));
                            },
                            hintText: "الخصم",
                            controller: disControlleer,
                          )),
                      SizedBox(
                          width: 100,
                          child: CustomTextField(
                            onChanged: (value) {
                              bloc.add(OnDiscountRatioChanged(
                                price: double.parse(priceControlleer.text),
                                amount:
                                    double.tryParse(disControlleer.text) ?? 0.0,
                                ratio: double.parse(value),
                              ));
                            },
                            hintText: "الخصم٪",
                            controller: disRatioControlleer,
                          )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 270,
                          child: CustomTextField(
                            onChanged: (value) {},
                            hintText: "الضريبة",
                            controller: taxControlleer,
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Footer Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * (110 / 366),
                    child: CustomButton(
                      text: "الغاء",
                      fontColor: const Color(0xff000000),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: const Color(0xffF3F3F3),
                    ),
                  ),
                  SizedBox(
                    width: width * (110 / 366),
                    child: CustomButton(
                      text: "موافق",
                      onPressed: () {
                        if (selectedItem != null) {
                          bloc.add(AddClientToInvoiceEvent(SalesDtlModel(
                            price: double.tryParse(priceControlleer.text),
                            disam: double.tryParse(disControlleer.text),
                            disratio: double.tryParse(disRatioControlleer.text),
                            id: selectedItem!.itemid,
                            itemId: selectedItem!.itemid,
                            itemName: selectedItem!.name,
                            qty: double.tryParse(qtyControlleer.text),
                            tax: double.tryParse(taxControlleer.text),
                          )));
                        }
                        Navigator.pop(context); // Close the popup
                      },
                      color: const Color(0xff39B3BD),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
