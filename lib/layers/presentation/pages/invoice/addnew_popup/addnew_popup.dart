import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/items_dropdown.dart';
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
int idx = 0;

class AddnewPopup extends StatelessWidget {
  const AddnewPopup(
      {super.key, required this.isEdit, this.toEdit, required this.headId});
  final bool isEdit;
  final SalesDtlModel? toEdit;
  final int headId;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();
    double width = MediaQuery.sizeOf(context).width;

    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (popped) {
        _resetControllers();
        myItems = [];
        selectedItem = null;
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
                  listener: (context, state) => _handleStateChange(state),
                  builder: (context, state) {
                    return _buildDropdown(state, bloc);
                  },
                ),
              ),
              const SizedBox(height: 12),
              // TextFields for price, discount, quantity
              _buildTextFields(bloc),
              const SizedBox(height: 20),
              // Footer Buttons
              _buildFooterButtons(context, width, bloc),
            ],
          ),
        ),
      ),
    );
  }

  void _resetControllers() {
    priceControlleer.clear();
    disControlleer.clear();
    disRatioControlleer.clear();
    taxControlleer.clear();
    qtyControlleer.clear();
    selectedItem = null;
    myItems = [];
  }

  void _handleStateChange(InvoiceState state) {
    if (state is EditState) {
      idx = state.index;
      myItems = state.items;
      // Populate controllers
      priceControlleer.text = state.salesDtlModel.price.toString();
      disControlleer.text = state.salesDtlModel.disam.toString();
      disRatioControlleer.text = state.salesDtlModel.disratio.toString();
      taxControlleer.text = state.salesDtlModel.tax.toString();
      qtyControlleer.text = state.salesDtlModel.qty.toString();

      // Set selectedItem based on itemId
      selectedItem = myItems.firstWhere(
        (item) => item.name == state.salesDtlModel.itemName,
      );
    } else if (state is DiscountChanged) {
      disControlleer.text = state.amount.toString();
      disRatioControlleer.text = state.ratio.toString();
    } else if (state is DiscountRatioChanged) {
      disControlleer.text = state.amount.toString();
      disRatioControlleer.text = state.ratio.toString();
    }
  }

  Widget _buildDropdown(InvoiceState state, InvoiceBloc bloc) {
    if (state is EditState) {
      _handleStateChange(state);
    }
    if (state is InvoiceLoaded) {
      myItems = state.clients;
      final selectedValue = state.clients
              .any((client) => client.name == state.selectedClient?.name)
          ? state.selectedClient
          : null;

      return SearchableItemDropdown(
          items: myItems,
          selecteditem: selectedValue,
          onItemSelected: (val) {
            if (val != null) {
              selectedItem = val;
              bloc.add(ClientSelectedEvent(val));
            }
          },
          width: double.infinity,
          onSearch: (val) {});
    } else if (state is InvoiceLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is InvoiceError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.red),
      );
    }

    return SearchableItemDropdown(
        items: myItems,
        selecteditem: selectedItem,
        onItemSelected: (val) {
          if (val != null) {
            selectedItem = val;
            bloc.add(ClientSelectedEvent(val));
          }
        },
        width: double.infinity,
        onSearch: (val) {});
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      labelText: "اختر الصنف",
      labelStyle: const TextStyle(fontFamily: 'Almarai'),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
    );
  }

  Widget _buildTextFields(InvoiceBloc bloc) {
    return Column(
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
              ),
            ),
            SizedBox(
              width: 100,
              child: CustomTextField(
                onChanged: (value) {},
                hintText: "السعر",
                controller: priceControlleer,
              ),
            ),
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
                  _handleDiscountChange(bloc, val);
                },
                hintText: "الخصم",
                controller: disControlleer,
              ),
            ),
            SizedBox(
              width: 100,
              child: CustomTextField(
                onChanged: (value) {
                  _handleDiscountRatioChange(bloc, value);
                },
                hintText: "الخصم٪",
                controller: disRatioControlleer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 270,
          child: CustomTextField(
            onChanged: (value) {},
            hintText: "الضريبة",
            controller: taxControlleer,
          ),
        ),
      ],
    );
  }

  void _handleDiscountChange(InvoiceBloc bloc, String val) {
    double? price = double.tryParse(priceControlleer.text);
    double? discount = double.tryParse(val);
    double? discountRatio = double.tryParse(disRatioControlleer.text);

    if (price != null && discount != null) {
      bloc.add(OnDiscountChanged(price,
          amount: discount, ratio: discountRatio ?? 0.0));
    }
  }

  void _handleDiscountRatioChange(InvoiceBloc bloc, String value) {
    double? price = double.tryParse(priceControlleer.text);
    double? discount = double.tryParse(disControlleer.text);
    double? ratio = double.tryParse(value);

    if (price != null && ratio != null) {
      bloc.add(OnDiscountRatioChanged(
          price: price, amount: discount ?? 0.0, ratio: ratio));
    }
  }

  Widget _buildFooterButtons(
      BuildContext context, double width, InvoiceBloc bloc) {
    return Row(
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
              _handleConfirm(context, bloc);
            },
            color: const Color(0xff39B3BD),
          ),
        ),
      ],
    );
  }

  void _handleConfirm(BuildContext context, InvoiceBloc bloc) {
    SalesDtlModel salesDtlModel = SalesDtlModel(
      price: double.tryParse(priceControlleer.text),
      disam: double.tryParse(disControlleer.text),
      disratio: double.tryParse(disRatioControlleer.text),
      id: headId.toString(),
      itemId: selectedItem?.itemid.toString(),
      itemName: selectedItem?.name.toString(),
      qty: double.tryParse(qtyControlleer.text),
      tax: double.tryParse(taxControlleer.text),
    );

    if (isEdit) {
      bloc.add(EditInvoiceItemEvent(salesDtlModel, idx));
    } else if (selectedItem != null) {
      bloc.add(AddClientToInvoiceEvent(salesDtlModel));
    }
    Navigator.pop(context);
  }
}
