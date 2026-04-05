import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/domain/models/mobile_item_units_model.dart';
import 'package:nilesoft_erp/layers/domain/models/settings_model.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/discount_list_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/mobile_item_units_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/price_list_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/settings_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/discount_list_model.dart';
import 'package:nilesoft_erp/layers/domain/models/price_list_model.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/sales_invoice_stock_validation.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/items_dropdown.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/units_dropdown.dart';
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

class AddnewPopup extends StatefulWidget {
  final List<SalesDtlModel> allDtl;
  const AddnewPopup(
      {super.key,
      required this.isEdit,
      this.toEdit,
      required this.headId,
      required this.allDtl,
      this.selectedCustomer});
  final bool isEdit;
  final SalesDtlModel? toEdit;
  final int headId;
  final CustomersModel? selectedCustomer;

  @override
  State<AddnewPopup> createState() => _AddnewPopupState();
}

class _AddnewPopupState extends State<AddnewPopup> {
  List<MobileItemUnitsModel> itemUnits = [];
  MobileItemUnitsModel? selectedUnit;
  double _priceListBase = 0;
  bool isMultiUnitEnabled = false;
  bool isDiscountDisabled = false;
  bool _editStateHandled = false;
  final PriceListRepoImpl _priceListLocal = PriceListRepoImpl();
  final DiscountListRepoImpl _discountListLocal = DiscountListRepoImpl();

  @override
  void initState() {
    super.initState();
    if (!widget.isEdit) {
      priceControlleer.text = '0.00';
      disControlleer.text = '0.00';
      disRatioControlleer.text = '0.00';
      taxControlleer.text = '0.00';
      qtyControlleer.text = '1';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  Future<void> _loadSettings() async {
    SettingsRepoImpl settingsRepo = SettingsRepoImpl();
    List<SettingsModel> settings = await settingsRepo.getSettings(
        tableName: DatabaseConstants.settingsTable);
    if (mounted) {
      setState(() {
        if (settings.isNotEmpty) {
          isMultiUnitEnabled = settings[0].multiunit == true;
          isDiscountDisabled = settings[0].disableItemDiscount == 1;
        }
      });
    }
  }

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
                  listener: (context, state) =>
                      _handleStateChange(state, context),
                  builder: (context, state) {
                    return _buildDropdown(state, bloc, context);
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
    _priceListBase = 0;
    priceControlleer.text = '0.00';
    disControlleer.text = '0.00';
    disRatioControlleer.text = '0.00';
    taxControlleer.text = '0.00';
    qtyControlleer.text = widget.isEdit ? '' : '1';
    selectedItem = null;
    myItems = [];
    _editStateHandled = false; // Reset the flag when resetting
    setState(() {
      itemUnits = [];
      selectedUnit = null;
    });
  }

  Future<void> _loadSettingsAndUnits() async {
    if (!mounted || selectedItem == null || selectedItem!.itemid == null) {
      if (mounted) {
        setState(() {
          itemUnits = [];
          selectedUnit = null;
        });
      }
      return;
    }

    // Store itemid in a local variable to avoid null check issues
    final itemId = selectedItem?.itemid;
    if (itemId == null) {
      if (mounted) {
        setState(() {
          itemUnits = [];
          selectedUnit = null;
        });
      }
      return;
    }

    SettingsRepoImpl settingsRepo = SettingsRepoImpl();
    List<SettingsModel> settings = await settingsRepo.getSettings(
        tableName: DatabaseConstants.settingsTable);

    bool multiUnitEnabled = false;
    if (settings.isNotEmpty) {
      multiUnitEnabled = settings[0].multiunit == true;
    }

    MobileItemUnitsRepoImpl unitsRepo = MobileItemUnitsRepoImpl();
    List<MobileItemUnitsModel> loadedUnits =
        await unitsRepo.getMobileItemUnitsByItemId(
            itemId: itemId, tableName: DatabaseConstants.mobileItemUnitsTable);

    // Always add the basic unit from the items table if it exists
    if (selectedItem!.unitid != null || selectedItem!.unitname != null) {
      // Create a unit from the item's unit information (basic unit)
      MobileItemUnitsModel itemUnit = MobileItemUnitsModel(
        itemid: selectedItem!.itemid,
        unitid: selectedItem!.unitid,
        unitname: selectedItem!.unitname,
        factor: selectedItem!.factor ??
            1.0, // Default factor to 1.0 if not provided
      );

      // Check if this unit already exists in loadedUnits (to avoid duplicates)
      bool unitExists = loadedUnits
          .any((unit) => unit.unitid == itemUnit.unitid && unit.unitid != null);

      // If not found, add the basic unit from items table
      if (!unitExists) {
        loadedUnits.insert(
            0, itemUnit); // Insert at the beginning as the basic unit
      }
    }

    if (mounted) {
      setState(() {
        isMultiUnitEnabled = multiUnitEnabled;
        itemUnits = loadedUnits;
        if (itemUnits.isNotEmpty && selectedUnit == null) {
          selectedUnit = itemUnits[0];
        }
      });
    }
    if (!widget.isEdit) {
      await _updatePriceFromPriceList();
    }
    if (mounted) {
      _updatePriceWithFactor();
    }
  }

  Future<void> _loadUnitsThenMaybeDiscount() async {
    await _loadSettingsAndUnits();
    if (!mounted) return;
    await _updateDiscountFromDiscountList();
  }

  /// Latest customer row from SQLite (includes pricelistid / dislistid after sync).
  Future<CustomersModel?> _resolveCustomerForLists() async {
    final CustomersModel? initial = widget.selectedCustomer;
    if (initial?.id == null) return initial;
    try {
      final CustomersRepoImpl repo = CustomersRepoImpl();
      return await repo.getCustomerById(
        id: int.parse(initial!.id!),
        tableName: DatabaseConstants.customersTable,
      );
    } catch (_) {
      return initial;
    }
  }

  Future<String?> _activeGomlaSetting() async {
    final SettingsRepoImpl settingsRepo = SettingsRepoImpl();
    final List<SettingsModel> settings = await settingsRepo.getSettings(
        tableName: DatabaseConstants.settingsTable);
    if (settings.isEmpty) return null;
    return settings[0].salesInvoiceGomlaDefault;
  }

  /// Positive list IDs only; null or zero means the customer is not assigned to that list.
  bool _hasCustomerListId(int? id) => id != null && id > 0;

  /// Treats numeric **zero** as “column empty” so we don’t show 0 when consumer price is set.
  String? _nonZeroPriceText(String? s) {
    if (s == null) return null;
    final t = s.trim();
    if (t.isEmpty || t == 'null') return null;
    final p = double.tryParse(t);
    if (p != null && p == 0) return null;
    return t;
  }

  String? _nonZeroPriceDouble(double? d) {
    if (d == null || d == 0) return null;
    return d.toString();
  }

  /// Gomla setting: "2" wholesale, "3" half; otherwise consumer (incl. "1" or unset).
  String? _priceValueForGomla(PriceListModel r, String? gomla) {
    String? primary;
    if (gomla == "2") {
      primary = _nonZeroPriceDouble(r.wholesaleprice) ??
          _nonZeroPriceText(r.consumerprice) ??
          _nonZeroPriceText(r.halfsaleprice);
    } else if (gomla == "3") {
      primary = _nonZeroPriceText(r.halfsaleprice) ??
          _nonZeroPriceDouble(r.wholesaleprice) ??
          _nonZeroPriceText(r.consumerprice);
    } else {
      primary = _nonZeroPriceText(r.consumerprice) ??
          _nonZeroPriceDouble(r.wholesaleprice) ??
          _nonZeroPriceText(r.halfsaleprice);
    }
    if (primary != null) return primary;
    return _nonZeroPriceText(r.consumerprice) ??
        _nonZeroPriceDouble(r.wholesaleprice) ??
        _nonZeroPriceText(r.halfsaleprice);
  }

  /// Same gomla codes as price: wholesale / half / consumer columns on the discount list row.
  String? _discountRatioForGomla(DiscountListModel r, String? gomla) {
    if (gomla == "2") return r.wholedisratio?.toString();
    if (gomla == "3") {
      final h = r.halfdisratio?.trim();
      if (h != null && h.isNotEmpty) return h;
    }
    final c = r.consumerdisratio?.trim();
    if (c != null && c.isNotEmpty) return c;
    if (r.wholedisratio != null) return r.wholedisratio.toString();
    final h2 = r.halfdisratio?.trim();
    if (h2 != null && h2.isNotEmpty) return h2;
    return null;
  }

  /// Customer `pricelistid` → `priceList` row (`listid` + line `itemid`) → price column from
  /// gomla setting (`salesinvoicegomladefault`: consumer / wholesale / half). Falls back to
  /// the item master price when unassigned, missing row, or empty list price.
  Future<void> _updatePriceFromPriceList() async {
    if (selectedItem?.itemid == null) return;

    final CustomersModel? cust = await _resolveCustomerForLists();
    final int? plId = cust?.pricelistid;

    double resolved = 0.0;
    if (_hasCustomerListId(plId)) {
      final priceRecord = await _priceListLocal.getPriceListItem(
        listId: plId.toString(),
        itemId: selectedItem!.itemid!.trim(),
      );
      
      if (priceRecord != null) {
        final gomla = await _activeGomlaSetting();
        final String? raw = _priceValueForGomla(priceRecord, gomla);
        if (raw != null && raw.trim().isNotEmpty) {
          final p = double.tryParse(raw);
          if (p != null) resolved = p;
        }
      }
    }
    if (resolved == 0.0 && selectedItem?.price != null) {
      resolved = selectedItem!.price!;
    }

    if (!mounted) return;
    setState(() {
      _priceListBase = resolved;
      priceControlleer.text = resolved.toStringAsFixed(2);
    });
  }

  void _applyZeroDiscountFields() {
    if (!mounted) return;
    disControlleer.text = '0.00';
    disRatioControlleer.text = '0.00';
    final bloc = context.read<InvoiceBloc>();
    _handleDiscountRatioChange(bloc, '0');
  }

  /// Customer `dislistid` → `discountList` row (`listid` + item `discountcatid`) → discount
  /// ratio column from the same gomla setting as price. Missing list/category/row clears
  /// list-driven discount (unless discounts are disabled globally).
  Future<void> _updateDiscountFromDiscountList() async {
    if (widget.isEdit) return;
    final CustomersModel? cust = await _resolveCustomerForLists();
    final double? catId = selectedItem?.discountcatid;
    if (!_hasCustomerListId(cust?.dislistid) || catId == null) {
      _applyZeroDiscountFields();
      return;
    }

    final record = await _discountListLocal.getDiscountListItem(
      listId: cust!.dislistid.toString(),
      catId: catId,
    );
    if (!mounted) return;
    if (record == null) {
      _applyZeroDiscountFields();
      return;
    }

    final gomla = await _activeGomlaSetting();
    final String? ratioStr = _discountRatioForGomla(record, gomla);
    if (ratioStr == null || ratioStr.trim().isEmpty) {
      _applyZeroDiscountFields();
      return;
    }

    final double ratio = double.tryParse(ratioStr) ?? 0.0;
    disRatioControlleer.text = ratio.toStringAsFixed(2);
    if (!mounted) return;
    final bloc = context.read<InvoiceBloc>();
    _handleDiscountRatioChange(bloc, disRatioControlleer.text);
  }

  void _updatePriceWithFactor() {
    if (selectedUnit == null || selectedUnit!.factor == null) return;
    final double adjusted = _priceListBase * selectedUnit!.factor!;
    priceControlleer.text = adjusted.toStringAsFixed(2);
  }

  void _handleStateChange(InvoiceState state, BuildContext context) {
    /// MobileScannerController controller = MobileScannerController();
    if (state is QRCodeScanning || state is QRCodeInitial) {
      // controller.start();

      showScannerDialog(context);
    }

    if (state is QRCodeSuccess) {
      selectedItem = state.item;
      _priceListBase = 0;
      taxControlleer.text = "0.00";
      disControlleer.text = "0.00";
      disRatioControlleer.text = "0.00";
      priceControlleer.text = "0.00";
      if (!widget.isEdit) qtyControlleer.text = "1";
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadUnitsThenMaybeDiscount();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code Found: ${state.qrCode}')),
      );
    }
    if (state is QRCodeFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error}')),
      );
    }
    if (state is InvoiceLoaded) {
      selectedItem = state.selectedClient;
      _priceListBase = 0;
      taxControlleer.text = "0.00";
      disControlleer.text = "0.00";
      disRatioControlleer.text = "0.00";
      priceControlleer.text = "0.00";
      if (!widget.isEdit) qtyControlleer.text = "1";
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadUnitsThenMaybeDiscount();
      });
    }
    if (state is EditState && !_editStateHandled) {
      // Only handle EditState once to prevent resetting controllers on every state change
      _editStateHandled = true;
      // Defer all state changes to after build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        idx = state.index;
        myItems = state.items;
        // Populate controllers
        priceControlleer.text =
            state.salesDtlModel[state.index].price.toString();
        disControlleer.text = state.salesDtlModel[state.index].disam.toString();
        disRatioControlleer.text =
            state.salesDtlModel[state.index].disratio.toString();
        taxControlleer.text = state.salesDtlModel[state.index].tax.toString();
        qtyControlleer.text = state.salesDtlModel[state.index].qty.toString();

        // Set selectedItem based on itemId
        selectedItem = myItems.firstWhere(
          (item) => item.name == state.salesDtlModel[state.index].itemName,
        );

        final SalesDtlModel editDtl = state.salesDtlModel[state.index];
        final double linePrice = editDtl.price ?? 0.0;
        final double? lineFactor = editDtl.factor;
        _priceListBase = (lineFactor != null && lineFactor != 0)
            ? linePrice / lineFactor
            : linePrice;

        _loadSettingsAndUnits().then((_) {
          if (mounted) {
            if (state.salesDtlModel[state.index].unitid != null) {
              setState(() {
                selectedUnit = itemUnits.firstWhere(
                  (unit) =>
                      unit.unitid == state.salesDtlModel[state.index].unitid,
                  orElse: () => itemUnits.isNotEmpty
                      ? itemUnits[0]
                      : MobileItemUnitsModel(),
                );
              });
              // Update price with the selected unit's factor
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updatePriceWithFactor();
              });
            } else if (itemUnits.isNotEmpty) {
              // If no unitid in saved data, use first unit and update price
              setState(() {
                selectedUnit = itemUnits[0];
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updatePriceWithFactor();
              });
            }
          }
        });
      });
    } else if (state is DiscountChanged) {
      disControlleer.text = state.amount.toString();
      disRatioControlleer.text = state.ratio.toString();
    } else if (state is DiscountRatioChanged) {
      disControlleer.text = state.amount.toString();
      disRatioControlleer.text = state.ratio.toString();
    }
  }

  Widget _buildDropdown(
      InvoiceState state, InvoiceBloc bloc, BuildContext context) {
    if (state is QRCodeSuccess) {
      selectedItem = state.item;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadUnitsThenMaybeDiscount();
      });
      return SearchableItemDropdown(
          items: myItems,
          selecteditem: state.item,
          onItemSelected: (val) {
            if (val != null) {
              selectedItem = val;
              setState(() {
                _priceListBase = 0;
                selectedUnit = null;
                itemUnits = [];
                priceControlleer.text = '0.00';
                disControlleer.text = '0.00';
                disRatioControlleer.text = '0.00';
                taxControlleer.text = '0.00';
              });
              bloc.add(ClientSelectedEvent(val));
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _loadUnitsThenMaybeDiscount();
              });
            }
          },
          width: double.infinity,
          onSearch: (val) {});
    }

    if (state is EditState) {
      _handleStateChange(state, context);
    }
    if (state is TextFoucsed) {
      state.controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: state.controller.text.length,
      );
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
              setState(() {
                _priceListBase = 0;
                selectedUnit = null;
                itemUnits = [];
                priceControlleer.text = '0.00';
                disControlleer.text = '0.00';
                disRatioControlleer.text = '0.00';
                taxControlleer.text = '0.00';
              });
              bloc.add(ClientSelectedEvent(val));
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _loadUnitsThenMaybeDiscount();
              });
            }
          },
          width: double.infinity,
          onSearch: (val) {});
    } else if (state is InvoiceLoading) {
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
    }

    return SearchableItemDropdown(
        items: myItems,
        selecteditem: selectedItem,
        onItemSelected: (val) {
          if (val != null) {
            selectedItem = val;
            setState(() {
              _priceListBase = 0;
              priceControlleer.text = '0.00';
              disControlleer.text = '0.00';
              disRatioControlleer.text = '0.00';
              taxControlleer.text = '0.00';
            });
            bloc.add(ClientSelectedEvent(val));
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await _loadUnitsThenMaybeDiscount();
            });
          }
        },
        width: double.infinity,
        onSearch: (val) {});
  }

  void showScannerDialog(BuildContext context) async {
    final bloc = context.read<InvoiceBloc>();
    //MobileScannerController controller = MobileScannerController();

    // Request Camera Permission
    //  final permissionStatus = await Permission.camera.request();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: AspectRatio(
            aspectRatio: 1, // Ensure square aspect ratio
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // Match dialog corners
              child: Container(
                color: Colors.black, // Black background for visibility
                child: MobileScanner(
                  // controller: controller,
                  onDetect: (BarcodeCapture barcodeCapture) {
                    final code = barcodeCapture.barcodes.first.rawValue;
                    if (code != null) {
                      bloc.add(QRCodeDetected(code));
                      if (kDebugMode) {
                        print('QR Code detected: $code');
                      }
                      Navigator.pop(dialogContext); // Close the dialog
                    }
                  },
                  // onError: (error) {
                  //   print('MobileScanner error: $error');
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('Scanner Error: $error')),
                  //   );
                  // },
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // controller.stop();
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFields(InvoiceBloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton(
            text: "اختيار بالباركود",
            onPressed: () {
              bloc.add(StartScanning());
            }),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: CustomTextField(
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                hintText: "الكمية",
                onTap: () {
                  if (kDebugMode) {
                    print("object");
                  }
                  bloc.add(OnTextTapped(controller: qtyControlleer));
                },
                controller: qtyControlleer,
              ),
            ),
            SizedBox(
              width: 100,
              child: CustomTextField(
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                hintText: "السعر",
                readonly: true,
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
                readonly: isDiscountDisabled,

                hintText: "الخصم",
                keyboardType: TextInputType.number,
                controller: disControlleer,
              ),
            ),
            SizedBox(
              width: 100,
              child: CustomTextField(
                onChanged: (value) {
                  _handleDiscountRatioChange(bloc, value);
                },
                readonly: isDiscountDisabled,
                hintText: "الخصم٪",
                keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
            controller: taxControlleer,
          ),
        ),
        if (itemUnits.isNotEmpty && isMultiUnitEnabled) ...[
          const SizedBox(height: 12),
          UnitsDropdown(
            units: itemUnits,
            selectedUnit: selectedUnit,
            onUnitSelected: (unit) {
              setState(() {
                selectedUnit = unit;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updatePriceWithFactor();
                if (!widget.isEdit) {
                  _updateDiscountFromDiscountList();
                }
              });
            },
            width: 270,
          ),
        ],
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
            onPressed: () async {
              await _handleConfirm(context, bloc);
            },
            color: const Color(0xff39B3BD),
          ),
        ),
      ],
    );
  }

  Future<void> _handleConfirm(BuildContext context, InvoiceBloc bloc) async {
    if (widget.isEdit) {
      final double? qtyEdit = double.tryParse(qtyControlleer.text);
      if (qtyEdit == null || qtyEdit <= 0) {
        _showSnackBar("برجاء إدخال كمية صحيحة", context);
        return;
      }
      final SalesDtlModel salesDtlModel = SalesDtlModel(
        innerid: widget.toEdit!.innerid,
        price: double.tryParse(priceControlleer.text),
        disam: double.tryParse(disControlleer.text),
        disratio: double.tryParse(disRatioControlleer.text),
        id: widget.headId.toString(),
        itemId: selectedItem?.itemid.toString(),
        itemName: selectedItem?.name.toString(),
        qty: qtyEdit,
        tax: double.tryParse(taxControlleer.text),
        unitid: selectedUnit?.unitid,
        unitname: selectedUnit?.unitname,
        factor: selectedUnit?.factor,
      );

      if (await salesInvoiceRestrictsToInStock()) {
        final List<SalesDtlModel> projected =
            List<SalesDtlModel>.from(widget.allDtl);
        projected[idx] = salesDtlModel;
        final String? err = await validateSalesInvoiceLinesAgainstStock(
          lines: projected,
          restrictToInStock: true,
        );
        if (err != null) {
          if (!context.mounted) return;
          _showSnackBar(err, context);
          return;
        }
      }

      if (!context.mounted) return;
      bloc.add(EditInvoiceItemEvent([salesDtlModel], idx, widget.allDtl));
      Navigator.pop(context);
      return;
    }

    if (selectedItem == null) {
      return;
    }
    final double? qtyParsed = double.tryParse(qtyControlleer.text);
    if (qtyParsed == null || qtyParsed <= 0) {
      _showSnackBar("برجاء إدخال كمية صحيحة", context);
      return;
    }

    final SalesDtlModel salesDtlModel = SalesDtlModel(
      price: double.tryParse(priceControlleer.text),
      disam: double.tryParse(disControlleer.text),
      disratio: double.tryParse(disRatioControlleer.text),
      id: widget.headId.toString(),
      itemId: selectedItem?.itemid.toString(),
      itemName: selectedItem?.name.toString(),
      qty: qtyParsed,
      tax: double.tryParse(taxControlleer.text),
      unitid: selectedUnit?.unitid,
      unitname: selectedUnit?.unitname,
      factor: selectedUnit?.factor,
    );

    if (await salesInvoiceRestrictsToInStock()) {
      final List<SalesDtlModel> projected =
          List<SalesDtlModel>.from(widget.allDtl)..add(salesDtlModel);
      final String? err = await validateSalesInvoiceLinesAgainstStock(
        lines: projected,
        restrictToInStock: true,
      );
      if (err != null) {
        if (!context.mounted) return;
        _showSnackBar(err, context);
        return;
      }
    }

    if (!context.mounted) return;
    bloc.add(AddClientToInvoiceEvent(salesDtlModel, widget.allDtl));
    Navigator.pop(context);
  }

  void _showSnackBar(String message, BuildContext context) {
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
