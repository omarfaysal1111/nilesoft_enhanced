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
import 'package:geolocator/geolocator.dart';
import 'package:nilesoft_erp/services/location_service.dart';
import 'dart:async';

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
  bool _isSaving = false;
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
      // ignore: deprecated_member_use
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
              // Don't show "Failed to fetch clients" error - it will retry automatically
              if (state.message.contains("Failed to fetch clients")) {
                return const Center(child: CircularProgressIndicator());
              }
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              );
            } else if (state is InvoicePageLoaded) {
              invoiceState.docNo = state.docNo.toString();
              invoiceState.customers = state.customers;
              invoiceState.headid = state.id!;

              // Apply discount ratio if customer is selected
              if (state.selectedCustomer != null) {
                invoiceState.selected = state.selectedCustomer;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _applyCustomerDiscount(state.selectedCustomer!, bloc);
                });
              }

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
          // Find the customer from the list to ensure we have the latest data including discountRatio
          CustomersModel? customerWithDiscount =
              invoiceState.customers?.firstWhere(
            (c) => c.id == value.id,
            orElse: () => value,
          );

          invoiceState.selected = customerWithDiscount ?? value;
          bloc.add(CustomerSelectedEvent(
              selectedCustomer: customerWithDiscount ?? value));
          // Always apply customer discount (even if 0, to clear previous customer's discount)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _applyCustomerDiscount(customerWithDiscount ?? value, bloc);
          });
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
                child: _isSaving
                    ? ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : CustomButton(
                        color: Colors.black87,
                        text: widget.isEditing
                            ? "تحديث الفاتورة"
                            : "حفظ الفاتورة",
                        onPressed: () async {
                          if (_isSaving) {
                            return;
                          }
                          await _handleSaveOrUpdate(bloc);
                        },
                      ),
              )
            : const SizedBox(),
        widget.sent != 1
            ? SizedBox(
                width: width * 0.4,
                child: CustomButton(
                  text: "اضافة صنف",
                  onPressed: () => _handleAddItem(bloc),
                ),
              )
            : const SizedBox(),
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
          // Set serial number if not already set
          if (invoiceState.dtl![index].serial == null) {
            invoiceState.dtl![index].serial = index + 1;
          }
          return InfoCard(
            title: invoiceState.dtl![index].itemName.toString(),
            price: invoiceState.dtl![index].price.toString(),
            discount: invoiceState.dtl![index].disam.toString(),
            quantity: invoiceState.dtl![index].qty.toString(),
            tax: invoiceState.dtl![index].tax.toString(),
            total: (invoiceState.dtl![index].price! * items[index].qty!)
                .toString(),
            serial: invoiceState.dtl![index].serial?.toString(),
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
  Future<void> _handleSaveOrUpdate(InvoiceBloc bloc) async {
    if (widget.isEditing) {
      await _handleUpdateInvoice(bloc);
    } else {
      await _handleSaveInvoice(bloc);
    }
  }

  Future<void> _handleSaveInvoice(InvoiceBloc bloc) async {
    if (_validateInvoice()) {
      setState(() {
        _isSaving = true;
      });
      var uuid = const Uuid();
      String mobileUuid = uuid.v1().toString();
      String formattedDate =
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formattedTime = intl.DateFormat('hh:mm').format(DateTime.now());

      // Get current location using LocationService
      Position? position = await LocationService.getCurrentLocation();
      double? longitude = position?.longitude;
      double? latitude = position?.latitude;

      // If location is null, show dialog and prevent saving
      if (longitude == null || latitude == null) {
        setState(() {
          _isSaving = false;
        });
        // ignore: use_build_context_synchronously
        bool shouldRetry =
            // ignore: use_build_context_synchronously
            await LocationService.showLocationPermissionDialog(context);
        if (shouldRetry) {
          // Retry getting location
          position = await LocationService.getCurrentLocation();
          longitude = position?.longitude;
          latitude = position?.latitude;

          // If still null, don't save
          if (longitude == null || latitude == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'لا يمكن حفظ الفاتورة بدون الموقع. يرجى منح إذن الموقع.'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
            return;
          }
        } else {
          // User cancelled or didn't grant permission
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'لا يمكن حفظ الفاتورة بدون الموقع. يرجى منح إذن الموقع.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }

      SalesHeadModel salesHeadModel = SalesHeadModel(
        accid: invoiceState.selected!.id,
        dis1: invoiceState.dis,
        invoiceno: invoiceState.docNo,
        sent: 0,
        invTime: formattedTime.toString(),
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
        longitude: longitude,
        latitude: latitude,
      );

      // Set serial numbers before saving
      for (int i = 0; i < invoiceState.dtl!.length; i++) {
        invoiceState.dtl![i].serial = i + 1;
      }

      bloc.add(SaveButtonClicked(
        salesHeadModel: salesHeadModel,
        salesDtlModel: invoiceState.dtl!,
      ));
    } else {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _handleUpdateInvoice(InvoiceBloc bloc) async {
    if (_validateInvoice()) {
      var uuid = const Uuid();
      String mobileUuid = uuid.v1().toString();
      String formattedDate =
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formattedTime = intl.DateFormat('hh:mm').format(DateTime.now());

      // Get current location using LocationService
      Position? position = await LocationService.getCurrentLocation();
      double? longitude = position?.longitude;
      double? latitude = position?.latitude;

      // If location is null, show dialog and prevent updating
      if (longitude == null || latitude == null) {
        setState(() {
          _isSaving = false;
        });
        // ignore: use_build_context_synchronously
        bool shouldRetry =
            // ignore: use_build_context_synchronously
            await LocationService.showLocationPermissionDialog(context);
        if (shouldRetry) {
          // Retry getting location
          position = await LocationService.getCurrentLocation();
          longitude = position?.longitude;
          latitude = position?.latitude;

          // If still null, don't update
          if (longitude == null || latitude == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'لا يمكن تحديث الفاتورة بدون الموقع. يرجى منح إذن الموقع.'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
            return;
          }
        } else {
          // User cancelled or didn't grant permission
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'لا يمكن تحديث الفاتورة بدون الموقع. يرجى منح إذن الموقع.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }

      SalesHeadModel salesHeadModel = SalesHeadModel(
        id: widget.editid,
        accid: invoiceState.selected!.id,
        dis1: invoiceState.dis,
        invoiceno: invoiceState.docNo,
        sent: 0,
        invTime: formattedTime.toString(),
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
        longitude: longitude,
        latitude: latitude,
      );

      // Set serial numbers before updating
      if (invoiceState.dtl != null) {
        for (int i = 0; i < invoiceState.dtl!.length; i++) {
          invoiceState.dtl![i].serial = i + 1;
        }
      }

      bloc.add(OnUpdateInvoice(
        headModel: salesHeadModel,
        dtlModel: invoiceState.dtl ?? [],
      ));
    } else {
      setState(() {
        _isSaving = false;
      });
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
    // Find the customer from the list to get discount_ratio
    CustomersModel? customer = state.customers.firstWhere(
      (c) => c.id == state.salesHeadModel.accid,
      orElse: () => CustomersModel(
        state.salesHeadModel.accid,
        state.salesHeadModel.clientName,
        state.salesHeadModel.invType,
      ),
    );
    invoiceState.selected = customer;

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
    setState(() {
      _isSaving = false;
    });
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
    setState(() {
      _isSaving = false;
    });
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

    // Calculate totals (this sets invoiceState.dis to item-level discounts only)
    invoiceState.calculateTotals();

    // Calculate subtotal (total before any discounts) for customer discount
    double subtotal = 0;
    if (invoiceState.dtl != null) {
      for (var item in invoiceState.dtl!) {
        subtotal += (item.qty ?? 0) * (item.price ?? 0);
      }
    }

    // If customer has discount_ratio, apply it automatically (summary level only)
    if (invoiceState.selected != null &&
        invoiceState.selected!.discountRatio != null &&
        invoiceState.selected!.discountRatio! > 0) {
      double discountRate = invoiceState.selected!.discountRatio!;
      // Calculate customer discount on subtotal (ignoring item-level discounts)
      double customerDiscountAmount = (discountRate / 100) * subtotal;

      disratController.text = discountRate.toStringAsFixed(2);
      disamController.text = customerDiscountAmount.toStringAsFixed(2);

      // Don't modify invoiceState.dis - it should only contain item-level discounts
      // Apply customer discount only in net calculation
      invoiceState.net = invoiceState.total -
          invoiceState.dis -
          customerDiscountAmount +
          invoiceState.tax;

      // Emit discount changed event to update UI
      final bloc = context.read<InvoiceBloc>();
      bloc.add(OnDisratChanged(
        invoiceState.total,
        invoiceState.dis,
        invoiceState.net,
        value: discountRate,
      ));
    } else {
      // Update discount amount based on current rate
      double discountRate = double.tryParse(disratController.text) ?? 0;
      double discountAmount = (discountRate / 100) * subtotal;
      disamController.text = discountAmount.toStringAsFixed(2);

      if (disamController.text == "0") {
        disratController.text = "0";
      }
    }
  }

  void _handleSummaryCardListener(BuildContext context, InvoiceState state) {
    if (state is DisamChanged) {
      // Calculate subtotal for customer discount
      // ignore: unused_local_variable
      double subtotal = 0;
      if (invoiceState.dtl != null) {
        for (var item in invoiceState.dtl!) {
          subtotal += (item.qty ?? 0) * (item.price ?? 0);
        }
      }

      // Customer discount amount (from summary card)
      double customerDiscount = state.amValue;

      // Net = total - item-level discounts (invoiceState.dis) - customer discount + tax
      invoiceState.net = invoiceState.total -
          invoiceState.dis -
          customerDiscount +
          invoiceState.tax;
      disratController.text = state.ratValue.toStringAsFixed(2);
      disamController.text = state.amValue.toStringAsFixed(2);
    }

    if (state is DisratChanged) {
      // Calculate subtotal for customer discount
      // ignore: unused_local_variable
      double subtotal = 0;
      if (invoiceState.dtl != null) {
        for (var item in invoiceState.dtl!) {
          subtotal += (item.qty ?? 0) * (item.price ?? 0);
        }
      }

      // Customer discount amount (from summary card)
      double customerDiscount = state.amValue;

      // Net = total - item-level discounts (invoiceState.dis) - customer discount + tax
      invoiceState.net = invoiceState.total -
          invoiceState.dis -
          customerDiscount +
          invoiceState.tax;
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

  void _applyCustomerDiscount(CustomersModel customer, InvoiceBloc bloc) {
    if (customer.discountRatio != null && customer.discountRatio! > 0) {
      disratController.text = customer.discountRatio!.toStringAsFixed(2);

      invoiceState.calculateTotals();

      double subtotal = 0;
      if (invoiceState.dtl != null) {
        for (var item in invoiceState.dtl!) {
          subtotal += (item.qty ?? 0) * (item.price ?? 0);
        }
      }

      double customerDiscountAmount =
          (customer.discountRatio! / 100) * subtotal;

      disamController.text = customerDiscountAmount.toStringAsFixed(2);

      invoiceState.net = invoiceState.total -
          invoiceState.dis -
          customerDiscountAmount +
          invoiceState.tax;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        bloc.add(OnDisratChanged(
          invoiceState.total,
          invoiceState.dis,
          invoiceState.net,
          value: customer.discountRatio!,
        ));
      });
    } else {
      disratController.text = "0";
      disamController.text = "0";
      invoiceState.calculateTotals();
    }
  }
}
