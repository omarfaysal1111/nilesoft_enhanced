import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/customers_dropdown.dart';
import 'package:nilesoft_erp/layers/presentation/components/info_card.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/components/summaray_card.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/Resales_popup/resales_popup.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_state.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nilesoft_erp/layers/presentation/pages/share_document/share_screen.dart';
import 'package:uuid/uuid.dart';

// Global controllers
final disamController = TextEditingController();
final disratController = TextEditingController();
final TextEditingController desc = TextEditingController();

// Resales state management class
class MyResalesState {
  List<ItemsModel> myClients = [];
  List<CustomersModel>? customers;
  List<SalesDtlModel> dtl = [];
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

  void reset() {
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
    editindex = -1;
  }

  void calculateTotals() {
    total = 0;
    net = 0;
    dis = 0;
    tax = 0;

    for (var item in dtl) {
      // Calculate item total before discount
      double itemTotal = (item.qty ?? 0) * (item.price ?? 0);
      // Add to running total
      total += itemTotal;

      // Add discounts and tax
      dis += (item.disam! * item.qty!);
      tax += item.tax! * item.qty! * item.price! / 100;
    }

    // Calculate final net amount
    net = total - dis + tax;
  }
}

class ResalesPage extends StatelessWidget {
  const ResalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResalesBloc()..add(ReInitializeDataEvent()),
      child: const ResalesPageContent(
        sent: 0,
      ),
    );
  }
}

class ResalesPageContent extends StatefulWidget {
  final int? editid;
  const ResalesPageContent({super.key, required this.sent, this.editid});
  final int sent;

  @override
  State<ResalesPageContent> createState() => _ResalesPageContentState();
}

class _ResalesPageContentState extends State<ResalesPageContent> {
  late MyResalesState resalesState;

  @override
  void initState() {
    super.initState();
    resalesState = MyResalesState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ResalesBloc>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return PopScope(
      onPopInvoked: (didPop) => resalesState.reset(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: height * 0.02),
                _buildCustomerDropdown(width, bloc),
                SizedBox(height: height * 0.02),
                _buildDescriptionField(width),
                _buildPaymentTypeRadio(bloc),
                SizedBox(height: height * 0.002),
                _buildActionButtons(width, bloc),
                SizedBox(height: height * 0.02),
                _buildResalesItemsList(),
              ],
            ),
            _buildSummaryCard(bloc),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildCustomerDropdown(double width, ResalesBloc bloc) {
    return SizedBox(
      width: width * 0.9,
      height: 57,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<ResalesBloc, ResalesState>(
          listener: _handleCustomerDropdownListener,
          builder: (context, state) {
            if (state is ResalesInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ResalesError) {
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              );
            } else if (state is ResalesPageLoaded) {
              resalesState.docNo = state.docNo.toString();
              resalesState.customers = state.customers;
              resalesState.headid = state.id!;
              return _buildSearchableDropdown(width, bloc);
            }
            return Column(
              children: [_buildSearchableDropdown(width, bloc)],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchableDropdown(double width, ResalesBloc bloc) {
    return SearchableDropdown(
      onSearch: (val) {},
      customers: resalesState.customers,
      selectedCustomer: resalesState.selected,
      onCustomerSelected: (value) {
        if (value != null) {
          resalesState.selected = value;
          bloc.add(ReCustomerSelectedEvent(selectedCustomer: value));
        }
      },
      width: width,
    );
  }

  Widget _buildDescriptionField(double width) {
    return SizedBox(
      width: width * 0.9,
      child: CustomTextField(
        hintText: "البيان",
        controller: desc,
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildPaymentTypeRadio(ResalesBloc bloc) {
    return BlocConsumer<ResalesBloc, ResalesState>(
      listener: (context, state) {
        if (state is CheckBoxSelected) {
          resalesState.selectedValue = state.value;
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text('اجل'),
                Radio<String>(
                  value: '1',
                  groupValue: resalesState.selectedValue,
                  onChanged: (String? value) {
                    bloc.add(OnSelectCheckBox(value: value!));
                  },
                ),
              ],
            ),
            const Text('نقدي'),
            Radio<String>(
              value: '0',
              groupValue: resalesState.selectedValue,
              onChanged: (String? value) {
                bloc.add(OnSelectCheckBox(value: value!));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(double width, ResalesBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: width * 0.4,
          child: widget.sent == 0
              ? CustomButton(
                  color: Colors.black87,
                  text: resalesState.isEditting
                      ? "تحديث الفاتورة"
                      : "حفظ الفاتورة",
                  onPressed: () => _handleSaveOrUpdate(bloc),
                )
              : const SizedBox(),
        ),
        SizedBox(
          width: width * 0.4,
          child: widget.sent == 0
              ? CustomButton(
                  text: "اضافة صنف",
                  onPressed: () => _handleAddItem(bloc),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildResalesItemsList() {
    return Expanded(
      child: BlocConsumer<ResalesBloc, ResalesState>(
        listener: _handleResalesItemsListener,
        builder: (context, state) {
          if (state is AddNewResalesState) {
            return _buildItemsList(state.chosenItems);
          }

          return resalesState.dtl.isEmpty
              ? _buildEmptyState()
              : _buildItemsList(resalesState.dtl);
        },
      ),
    );
  }

  Widget _buildItemsList(List<SalesDtlModel> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 220.0),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: resalesState.dtl.length,
        itemBuilder: (context, index) {
          return InfoCard(
            title: resalesState.dtl[index].itemName.toString(),
            price: resalesState.dtl[index].price.toString(),
            discount: resalesState.dtl[index].disam.toString(),
            quantity: resalesState.dtl[index].qty.toString(),
            tax: (((resalesState.dtl[index].tax ?? 0) / 100) *
                    (resalesState.dtl[index].qty ?? 0) *
                    (resalesState.dtl[index].price ?? 0))
                .toStringAsFixed(2),
            total: ((resalesState.dtl[index].qty ?? 0) *
                    (resalesState.dtl[index].price ?? 0))
                .toString(),
            onDelete: () => _handleDeleteItem(index),
            onEdit: () => _handleEditItem(index),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Column(
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
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(ResalesBloc bloc) {
    return BlocConsumer<ResalesBloc, ResalesState>(
      listener: _handleSummaryCardListener,
      builder: (context, state) {
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
              total: resalesState.total.toString(),
              disamController: disamController,
              disratController: disratController,
              discount: resalesState.dis.toString(),
              tax: resalesState.tax.toString(),
              net: resalesState.net.toString(),
              amChanged: (String value) =>
                  _handleDiscountAmountChange(value, bloc),
              ratChanged: (String value) =>
                  _handleDiscountRateChange(value, bloc),
            ),
          ),
        );
      },
    );
  }

  // Event handlers
  void _handleSaveOrUpdate(ResalesBloc bloc) {
    if (resalesState.isEditting) {
      _handleUpdateResale(bloc);
    } else {
      _handleSaveResale(bloc);
    }
  }

  void _handleSaveResale(ResalesBloc bloc) {
    if (_validateResale()) {
      var uuid = const Uuid();
      String mobileUuid = uuid.v1().toString();
      String formattedDate =
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now());

      SalesHeadModel salesHeadModel = SalesHeadModel(
        accid: resalesState.selected!.id,
        dis1: resalesState.dis,
        invoiceno: resalesState.docNo,
        sent: 0,
        disam: double.parse(disamController.text),
        disratio: double.tryParse(disratController.text) ?? 0,
        net: resalesState.net,
        docDate: formattedDate,
        invType: resalesState.selectedValue,
        mobile_uuid: mobileUuid,
        tax: resalesState.tax,
        total: resalesState.total,
        clientName: resalesState.selected!.name,
        descr: desc.text,
      );

      bloc.add(ReSaveButtonClicked(
        salesHeadModel: salesHeadModel,
        salesDtlModel: resalesState.dtl,
      ));
    }
  }

  void _handleUpdateResale(ResalesBloc bloc) {
    if (_validateResale()) {
      String formattedDate =
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
      var uuid = const Uuid();
      String mobileUuid = uuid.v1().toString();
      SalesHeadModel salesHeadModel = SalesHeadModel(
        accid: resalesState.selected!.id,
        dis1: resalesState.dis,
        invoiceno: resalesState.docNo,
        sent: 0,
        id: widget.editid,
        net: resalesState.net,
        docDate: formattedDate,
        invType: resalesState.selectedValue,
        tax: resalesState.tax,
        disam: double.tryParse(disamController.text) ?? 0,
        disratio: double.tryParse(disratController.text) ?? 0,
        mobile_uuid: mobileUuid,
        total: resalesState.total,
        clientName: resalesState.selected!.name,
        descr: desc.text,
      );

      bloc.add(OnUpdateResale(
        headModel: salesHeadModel,
        dtlModel: resalesState.dtl,
      ));
    }
  }

  bool _validateResale() {
    if (resalesState.selected == null) {
      _showSnackBar("برجاء اختيار العميل");
      return false;
    }

    if (resalesState.dtl.isEmpty) {
      _showSnackBar("برجاء اضافة صنف واحد علي الاقل");
      return false;
    }

    return true;
  }

  void _handleAddItem(ResalesBloc bloc) {
    bloc.add(ReFetchClientsEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: BlocProvider.of<ResalesBloc>(context),
            child: AddnewPopup(
              id: resalesState.headid,
              allDtl: resalesState.dtl,
              headid: resalesState.headid,
              isEdit: false,
            ),
          );
        },
      );
    });
  }

  void _handleDeleteItem(int index) {
    final bloc = context.read<ResalesBloc>();
    resalesState.dtl.removeAt(index);
    resalesState.calculateTotals();
    bloc.add(ReOnDeleteCard());
  }

  void _handleEditItem(int index) {
    final bloc = context.read<ResalesBloc>();
    resalesState.editindex = index;
    bloc.add(ReEditPressed(
      salesDtlModel: resalesState.dtl[index],
      index: index,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: BlocProvider.of<ResalesBloc>(context),
            child: AddnewPopup(
              isEdit: true,
              allDtl: resalesState.dtl,
              headid: resalesState.headid,
              id: resalesState.headid,
              toEdit: resalesState.dtl[index],
            ),
          );
        },
      );
    });
  }

  void _handleDiscountAmountChange(String value, ResalesBloc bloc) {
    double amValue = double.tryParse(value) ?? 0;
    resalesState.net = resalesState.total - amValue + resalesState.tax;
    bloc.add(OnDisamChanged(
        resalesState.total, resalesState.dis, resalesState.net,
        value: amValue));
  }

  void _handleDiscountRateChange(String value, ResalesBloc bloc) {
    double ratValue = double.tryParse(value) ?? 0;
    double amValue = (ratValue / 100) * resalesState.total;
    resalesState.net = resalesState.total - amValue + resalesState.tax;
    bloc.add(OnDisratChanged(
        resalesState.total, resalesState.dis, resalesState.net,
        value: ratValue));
  }

  // Bloc listeners
  void _handleCustomerDropdownListener(
      BuildContext context, ResalesState state) {
    if (state is ResalesInitial) {
      resalesState.reset();
    }

    if (state is ResaleToEdit) {
      _handleEditModeInitialization(state);
    }

    if (state is ReSaveSuccess) {
      _handleSaveSuccess(context, state);
    }

    if (state is ResaleUpdateSucc) {
      _handleUpdateSuccess(context);
    }
  }

  void _handleEditModeInitialization(ResaleToEdit state) {
    resalesState.dtl = state.salesDtlModel;
    resalesState.customers = state.customers;

    disamController.text = state.salesHeadModel.disam.toString();
    disratController.text = state.salesHeadModel.disratio.toString();
    resalesState.selected = CustomersModel(
      state.salesHeadModel.accid,
      state.salesHeadModel.clientName,
      state.salesHeadModel.invType,
    );
    resalesState.isEditting = true;

    for (var item in state.salesDtlModel) {
      resalesState.total += (item.qty ?? 0) * (item.price ?? 0);
      resalesState.dis += (item.disam! * item.qty!);
      resalesState.tax += item.tax! * item.qty! * item.price! / 100;
    }
    resalesState.net = resalesState.total - resalesState.dis + resalesState.tax;
  }

  void _handleSaveSuccess(BuildContext context, ReSaveSuccess state) {
    _showSnackBar("تم حفظ الفاتورة");

    var uuid = const Uuid();
    String mobileUuid = uuid.v1().toString();
    String formattedDate = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());

    SalesHeadModel salesHeadModel = SalesHeadModel(
      accid: resalesState.selected!.id,
      dis1: resalesState.dis,
      invoiceno: resalesState.docNo,
      sent: 0,
      net: resalesState.net,
      disam: double.parse(disamController.text),
      disratio: double.tryParse(disratController.text) ?? 0,
      docDate: formattedDate,
      mobile_uuid: mobileUuid,
      tax: resalesState.tax,
      total: resalesState.total,
      clientName: resalesState.selected!.name,
      descr: desc.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrintingScreen(
          printingSalesDtlModel: resalesState.dtl,
          printingSalesHeadModel: salesHeadModel,
          id: salesHeadModel.accid.toString(),
          numOfSerials: 0,
        ),
      ),
    ).then((o) => resalesState.reset());
  }

  void _handleUpdateSuccess(BuildContext context) {
    resalesState.reset();
    _showSnackBar("تم تعديل الفاتورة");
    Navigator.pop(context);
  }

  void _handleResalesItemsListener(BuildContext context, ResalesState state) {
    if (state is ResalesEdittedState) {
      resalesState.dtl[state.index] = state.editedItem;
      final bloc = context.read<ResalesBloc>();
      bloc.add(ResalesPageLoded());
    }

    if (state is ResalesInitial) {
      resalesState.dtl = [];
    }

    if (state is AddNewResalesState) {
      _handleAddNewResalesState(state);
    }
  }

  void _handleAddNewResalesState(AddNewResalesState state) {
    resalesState.dtl = state.chosenItems;

    resalesState.calculateTotals();

    // Update discount amount based on rate
    double discountRate = double.tryParse(disratController.text) ?? 0;
    double discountAmount = (discountRate / 100) * resalesState.total;
    disamController.text = discountAmount.toStringAsFixed(2);

    if (disamController.text == "0") {
      disratController.text = "0";
    }
  }

  void _handleSummaryCardListener(BuildContext context, ResalesState state) {
    if (state is DisamChanged) {
      resalesState.net = resalesState.total -
          state.amValue +
          resalesState.tax -
          resalesState.dis;
      disratController.text = state.ratValue.toStringAsFixed(2);
      disamController.text = state.amValue.toStringAsFixed(2);
    }

    if (state is DisratChanged) {
      resalesState.net = resalesState.total -
          state.amValue +
          resalesState.tax -
          resalesState.dis;
      disratController.text = state.ratValue.toStringAsFixed(2);
      disamController.text = state.amValue.toStringAsFixed(2);
    }
  }

  void _showSnackBar(String message) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
