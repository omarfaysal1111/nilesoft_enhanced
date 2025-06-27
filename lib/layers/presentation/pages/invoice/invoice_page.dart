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

// Global controllers
final disamController = TextEditingController();
final disratController = TextEditingController();
final TextEditingController desc = TextEditingController();

// Invoice state management class
class MyInvoiceState {
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

    if (dtl != null) {
      for (var item in dtl!) {
        double itemTotal = (item.qty ?? 0) * (item.price ?? 0);
        total += itemTotal;
        dis += (item.disam! * item.qty!);
        tax += item.tax! * item.qty! * item.price! / 100;
      }
    }
    net = total - dis + tax;
  }
}

class InvoicePage extends StatelessWidget {
  const InvoicePage({
    super.key,
    required this.extraTitle,
    required this.invoiceType,
    this.editingInvoice,
  });

  final String extraTitle;
  final int invoiceType;
  final SalesHeadModel? editingInvoice; // For editing mode

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceBloc()..add(InitializeDataEvent()),
      child: editingInvoice != null
          ? InvoiceEditingContent(
              extraTitle: extraTitle,
              invoiceType: invoiceType,
            )
          : InvoiceAddingContent(
              extraTitle: extraTitle,
              invoiceType: invoiceType,
            ),
    );
  }
}

// Widget for adding new invoices
class InvoiceAddingContent extends StatelessWidget {
  const InvoiceAddingContent({
    super.key,
    required this.extraTitle,
    required this.invoiceType,
  });

  final String extraTitle;
  final int invoiceType;

  @override
  Widget build(BuildContext context) {
    return InvoicePageContent(
      extraTitle: extraTitle,
      invoiceType: invoiceType,
      isEditing: false,
    );
  }
}

// Widget for editing existing invoices
class InvoiceEditingContent extends StatelessWidget {
  final int? editid;
  final int? sent;
  const InvoiceEditingContent({
    super.key,
    required this.extraTitle,
    required this.invoiceType,
    this.editid,
    this.sent,
  });

  final String extraTitle;
  final int invoiceType;
  //final SalesHeadModel editingInvoice;

  @override
  Widget build(BuildContext context) {
    return InvoicePageContent(
      extraTitle: extraTitle,
      invoiceType: invoiceType,
      isEditing: true,
      sent: sent,
      editid: editid,
      //editingInvoice: editingInvoice,
    );
  }
}

// Main content widget that handles both adding and editing
class InvoicePageContent extends StatefulWidget {
  const InvoicePageContent({
    super.key,
    required this.extraTitle,
    required this.invoiceType,
    required this.isEditing,
    this.editingInvoice,
    this.editid,
    this.sent,
  });
  final int? editid;

  final String extraTitle;
  final int invoiceType;
  final bool isEditing;
  final SalesHeadModel? editingInvoice;
  final int? sent;

  @override
  State<InvoicePageContent> createState() => _InvoicePageContentState();
}

class _InvoicePageContentState extends State<InvoicePageContent> {
  late MyInvoiceState invoiceState;

  @override
  void initState() {
    super.initState();
    invoiceState = MyInvoiceState();

    if (widget.isEditing && widget.editingInvoice != null) {
      _initializeEditingMode();
    }
  }

  void _initializeEditingMode() {
    // Initialize editing mode with existing invoice data
    invoiceState.isEditting = true;
    // Set other editing-specific initialization here
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return PopScope(
      onPopInvoked: (didPop) => invoiceState.reset(),
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
                _buildInvoiceItemsList(),
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              widget.isEditing
                  ? "تعديل فاتورة ${widget.extraTitle}"
                  : "فاتورة ${widget.extraTitle}",
              style: const TextStyle(
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

  Widget _buildCustomerDropdown(double width, InvoiceBloc bloc) {
    return SizedBox(
      width: width * 0.9,
      height: 57,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<InvoiceBloc, InvoiceState>(
          listener: _handleCustomerDropdownListener,
          builder: (context, state) {
            if (state is InvoiceInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvoiceError) {
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              );
            } else if (state is InvoicePageLoaded) {
              invoiceState.docNo = state.docNo.toString();
              invoiceState.customers = state.customers;
              invoiceState.headid = state.id!;
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

  Widget _buildSearchableDropdown(double width, InvoiceBloc bloc) {
    return SearchableDropdown(
      onSearch: (val) {},
      customers: invoiceState.customers,
      selectedCustomer: invoiceState.selected,
      onCustomerSelected: (value) {
        if (value != null) {
          invoiceState.selected = value;
          bloc.add(CustomerSelectedEvent(selectedCustomer: value));
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

  Widget _buildPaymentTypeRadio(InvoiceBloc bloc) {
    return BlocConsumer<InvoiceBloc, InvoiceState>(
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
                  groupValue: invoiceState.selectedValue,
                  onChanged: (String? value) {
                    bloc.add(OnSelectCheckBox(value: value!));
                  },
                ),
              ],
            ),
            const Text('نقدي'),
            Radio<String>(
              value: '0',
              groupValue: invoiceState.selectedValue,
              onChanged: (String? value) {
                bloc.add(OnSelectCheckBox(value: value!));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(double width, InvoiceBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        widget.sent != 1
            ? SizedBox(
                width: width * 0.4,
                child: CustomButton(
                  color: Colors.black87,
                  text: widget.isEditing ? "تحديث الفاتورة" : "حفظ الفاتورة",
                  onPressed: () => _handleSaveOrUpdate(bloc),
                ),
              )
            : SizedBox(),
        widget.sent != 1
            ? SizedBox(
                width: width * 0.4,
                child: CustomButton(
                  text: "اضافة صنف",
                  onPressed: () => _handleAddItem(bloc),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Widget _buildInvoiceItemsList() {
    return Expanded(
      child: BlocConsumer<InvoiceBloc, InvoiceState>(
        listener: _handleInvoiceItemsListener,
        builder: (context, state) {
          if (state is AddNewInvoiceState) {
            return _buildItemsList(state.chosenItems);
          }

          return invoiceState.dtl == null || invoiceState.dtl!.isEmpty
              ? _buildEmptyState()
              : _buildItemsList(invoiceState.dtl!);
        },
      ),
    );
  }

  Widget _buildItemsList(List<SalesDtlModel> items) {
    items = invoiceState.dtl ?? [];
    return Padding(
      padding: const EdgeInsets.only(bottom: 220.0),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: invoiceState.dtl!.length,
        itemBuilder: (context, index) {
          return InfoCard(
            title: invoiceState.dtl![index].itemName.toString(),
            price: invoiceState.dtl![index].price.toString(),
            discount: invoiceState.dtl![index].disam.toString(),
            quantity: invoiceState.dtl![index].qty.toString(),
            tax: invoiceState.dtl![index].tax.toString(),
            total: (invoiceState.dtl![index].price! * items[index].qty!)
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

  Widget _buildSummaryCard(InvoiceBloc bloc) {
    return BlocConsumer<InvoiceBloc, InvoiceState>(
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
              total: invoiceState.total.toString(),
              disamController: disamController,
              disratController: disratController,
              discount: invoiceState.dis.toString(),
              tax: invoiceState.tax.toString(),
              net: invoiceState.net.toString(),
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

  // Event handlers for adding mode
  void _handleSaveOrUpdate(InvoiceBloc bloc) {
    if (widget.isEditing) {
      _handleUpdateInvoice(bloc);
    } else {
      _handleSaveInvoice(bloc);
    }
  }

  void _handleSaveInvoice(InvoiceBloc bloc) {
    if (_validateInvoice()) {
      var uuid = const Uuid();
      String mobileUuid = uuid.v1().toString();
      String formattedDate =
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now());

      SalesHeadModel salesHeadModel = SalesHeadModel(
        accid: invoiceState.selected!.id,
        dis1: invoiceState.dis,
        invoiceno: invoiceState.docNo,
        sent: 0,
        disam: double.parse(disamController.text),
        disratio: double.tryParse(disratController.text) ?? 0,
        net: invoiceState.net,
        docDate: formattedDate,
        invType: invoiceState.selectedValue,
        mobile_uuid: mobileUuid,
        tax: invoiceState.tax,
        total: invoiceState.total,
        clientName: invoiceState.selected!.name,
        descr: desc.text,
      );

      bloc.add(SaveButtonClicked(
        salesHeadModel: salesHeadModel,
        salesDtlModel: invoiceState.dtl!,
      ));
    }
  }

  void _handleUpdateInvoice(InvoiceBloc bloc) {
    if (_validateInvoice()) {
      var uuid = const Uuid();
      String mobileUuid = uuid.v1().toString();
      String formattedDate =
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now());

      SalesHeadModel salesHeadModel = SalesHeadModel(
        id: widget.editid,
        accid: invoiceState.selected!.id,
        dis1: invoiceState.dis,
        invoiceno: invoiceState.docNo,
        sent: 0,
        disam: double.parse(disamController.text),
        disratio: double.tryParse(disratController.text) ?? 0,
        net: invoiceState.net,
        docDate: formattedDate,
        invType: invoiceState.selectedValue,
        mobile_uuid: mobileUuid,
        tax: invoiceState.tax,
        total: invoiceState.total,
        clientName: invoiceState.selected!.name,
        descr: desc.text,
      );

      bloc.add(OnUpdateInvoice(
        headModel: salesHeadModel,
        dtlModel: invoiceState.dtl ?? [],
      ));
    }
  }

  bool _validateInvoice() {
    if (invoiceState.selected == null) {
      _showSnackBar("برجاء اختيار العميل");
      return false;
    }

    if (invoiceState.dtl == null || invoiceState.dtl!.isEmpty) {
      _showSnackBar("برجاء اضافة صنف واحد علي الاقل");
      return false;
    }

    return true;
  }

  void _handleAddItem(InvoiceBloc bloc) {
    bloc.add(FetchClientsEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: BlocProvider.of<InvoiceBloc>(context),
            child: AddnewPopup(
              isEdit: false,
              allDtl: invoiceState.dtl!,
              headId: invoiceState.headid,
            ),
          );
        },
      );
    });
  }

  void _handleDeleteItem(int index) {
    final bloc = context.read<InvoiceBloc>();
    invoiceState.dtl!.removeAt(index);
    invoiceState.calculateTotals();
    bloc.add(OnDeleteCard());
  }

  void _handleEditItem(int index) {
    final bloc = context.read<InvoiceBloc>();
    invoiceState.editindex = index;

    bloc.add(EditPressed(
      salesDtlModel: invoiceState.dtl ?? [],
      index: index,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: BlocProvider.of<InvoiceBloc>(context),
            child: AddnewPopup(
              isEdit: true,
              headId: invoiceState.headid,
              allDtl: invoiceState.dtl!,
              toEdit: invoiceState.dtl?[index],
            ),
          );
        },
      );
    });
  }

  void _handleDiscountAmountChange(String value, InvoiceBloc bloc) {
    double amValue = double.tryParse(value) ?? 0;
    invoiceState.net = invoiceState.total - amValue + invoiceState.tax;
    bloc.add(OnDisamChanged(
        invoiceState.total, invoiceState.dis, invoiceState.net,
        value: amValue));
  }

  void _handleDiscountRateChange(String value, InvoiceBloc bloc) {
    double ratValue = double.tryParse(value) ?? 0;
    double amValue = (ratValue / 100) * invoiceState.total;
    invoiceState.net = invoiceState.total - amValue + invoiceState.tax;
    bloc.add(OnDisratChanged(
        invoiceState.total, invoiceState.dis, invoiceState.net,
        value: ratValue));
  }

  // Bloc listeners
  void _handleCustomerDropdownListener(
      BuildContext context, InvoiceState state) {
    if (state is InvoiceInitial) {
      invoiceState.reset();
    }

    if (state is CheckBoxSelected) {
      invoiceState.selectedValue = state.value;
    }

    if (state is HasSerialState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SerialsBloc()
              ..add(OnSerialInit(
                invId: invoiceState.headid.toString(),
                lenOfSerials: state.len,
              )),
            child: const SerialsPage(),
          ),
        ),
      );
    }

    if (state is InvoiceToEdit) {
      _handleEditModeInitialization(state);
    }

    if (state is SaveSuccess) {
      _handleSaveSuccess(context, state);
    }

    if (state is UpdateSucc) {
      _handleUpdateSuccess(context);
    }
  }

  void _handleEditModeInitialization(InvoiceToEdit state) {
    invoiceState.dtl = state.salesDtlModel;
    invoiceState.headid = state.salesHeadModel.id ?? 0;
    invoiceState.isEditting = true;
    invoiceState.customers = state.customers;
    disamController.text = state.salesHeadModel.disam.toString();
    disratController.text = state.salesHeadModel.disratio.toString();
    invoiceState.selected = CustomersModel(
      state.salesHeadModel.accid,
      state.salesHeadModel.clientName,
      state.salesHeadModel.invType,
    );

    final myDtl = state.salesDtlModel;
    for (var i = 0; i < myDtl.length; i++) {
      invoiceState.dis +=
          invoiceState.dtl![i].disam! * invoiceState.dtl![i].qty!;
      invoiceState.tax += invoiceState.dtl![i].tax! * invoiceState.dtl![i].qty!;
      invoiceState.total +=
          invoiceState.dtl![i].price! * invoiceState.dtl![i].qty!;
      invoiceState.net =
          invoiceState.total - invoiceState.dis + invoiceState.tax;
    }
  }

  void _handleSaveSuccess(BuildContext context, SaveSuccess state) {
    _showSnackBar("تم حفظ الفاتورة");

    var uuid = const Uuid();
    String mobileUuid = uuid.v1().toString();
    String formattedDate = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());

    SalesHeadModel salesHeadModel = SalesHeadModel(
      accid: invoiceState.selected!.id,
      dis1: invoiceState.dis,
      invoiceno: invoiceState.docNo,
      invType: invoiceState.selectedValue,
      sent: 0,
      disam: double.tryParse(disamController.text) ?? 0,
      disratio: double.tryParse(disratController.text) ?? 0,
      net: invoiceState.net,
      docDate: formattedDate,
      mobile_uuid: mobileUuid,
      tax: invoiceState.tax,
      total: invoiceState.total,
      clientName: invoiceState.selected!.name,
      descr: desc.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrintingScreen(
          printingSalesDtlModel: invoiceState.dtl!,
          printingSalesHeadModel: salesHeadModel,
          id: salesHeadModel.accid.toString(),
          numOfSerials: 0,
        ),
      ),
    ).then((o) => invoiceState.reset());
  }

  void _handleUpdateSuccess(BuildContext context) {
    invoiceState.reset();
    _showSnackBar("تم تعديل الفاتورة");
    Navigator.pop(context);
  }

  void _handleInvoiceItemsListener(BuildContext context, InvoiceState state) {
    if (state is CardDeleted) {
      invoiceState.dtl = invoiceState.dtl;
    }

    if (state is InvoiceEdittedState) {
      invoiceState.dtl?[state.index] = state.editedItem;
      final bloc = context.read<InvoiceBloc>();
      bloc.add(InvoicePageLoded());
    }

    if (state is InvoiceInitial) {
      invoiceState.dtl = [];
    }

    if (state is AddNewInvoiceState) {
      _handleAddNewInvoiceState(state);
    }
  }

  void _handleAddNewInvoiceState(AddNewInvoiceState state) {
    invoiceState.dtl = state.chosenItems;

    invoiceState.calculateTotals();

    // Update discount amount based on rate
    double discountRate = double.tryParse(disratController.text) ?? 0;
    double discountAmount = (discountRate / 100) * invoiceState.total;
    disamController.text = discountAmount.toStringAsFixed(2);

    if (disamController.text == "0") {
      disratController.text = "0";
    }
  }

  void _handleSummaryCardListener(BuildContext context, InvoiceState state) {
    if (state is DisamChanged) {
      invoiceState.net = (invoiceState.total + invoiceState.tax) -
          invoiceState.dis -
          state.amValue;
      disratController.text = state.ratValue.toStringAsFixed(2);
      disamController.text = state.amValue.toStringAsFixed(2);
    }

    if (state is DisratChanged) {
      invoiceState.net = (invoiceState.total + invoiceState.tax) -
          invoiceState.dis -
          state.amValue;
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
