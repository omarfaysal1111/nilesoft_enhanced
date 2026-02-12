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
import 'package:geolocator/geolocator.dart';
import 'package:nilesoft_erp/services/location_service.dart';

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
  bool _isSaving = false;
  @override
  void initState() {
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
                        setState(() {
                          _isSaving = false;
                        });
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
                        setState(() {
                          _isSaving = false;
                        });
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
                mysent == 1
                    ? CustomButton(
                        text: "انهاء سند القبض النقدي",
                        onPressed: () {
                          //  Navigator.pop(context);
                        },
                      )
                    : _isSaving
                        ? ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff39B3BD),
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
                            text: "انهاء سند القبض النقدي",
                            onPressed: () async {
                              if (_isSaving) {
                                return;
                              }
                              setState(() {
                                _isSaving = true;
                              });
                              String formattedDate =
                                  intl.DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());
                              var uuid = const Uuid();
                              String mobileUuid = uuid.v1().toString();

                              // Get current location using LocationService
                              Position? position =
                                  await LocationService.getCurrentLocation();
                              double? longitude = position?.longitude;
                              double? latitude = position?.latitude;

                              // If location is null, show dialog and prevent saving
                              if (longitude == null || latitude == null) {
                                setState(() {
                                  _isSaving = false;
                                });
                                // ignore: use_build_context_synchronously
                                bool shouldRetry = await LocationService
                                    // ignore: use_build_context_synchronously
                                    .showLocationPermissionDialog(context);
                                if (shouldRetry) {
                                  // Retry getting location
                                  position = await LocationService
                                      .getCurrentLocation();
                                  longitude = position?.longitude;
                                  latitude = position?.latitude;

                                  // If still null, don't save
                                  if (longitude == null || latitude == null) {
                                    if (mounted) {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'لا يمكن حفظ سند القبض بدون الموقع. يرجى منح إذن الموقع.'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                    return;
                                  }
                                } else {
                                  // User cancelled or didn't grant permission
                                  if (mounted) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'لا يمكن حفظ سند القبض بدون الموقع. يرجى منح إذن الموقع.'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                  return;
                                }
                              }

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
                                    longitude: longitude,
                                    latitude: latitude,
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
                                    longitude: longitude,
                                    latitude: latitude,
                                  ),
                                ));
                              }
                              // Note: _isSaving will be reset in the success/error handlers
                              Navigator.push(
                                  // ignore: use_build_context_synchronously
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
                                            longitude: longitude,
                                            latitude: latitude,
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
                            }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
