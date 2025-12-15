import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_model.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_parameter_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/date_picker.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/customers_dropdown.dart';
import 'package:nilesoft_erp/layers/presentation/components/ledger_info_card.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/components/summaray_card_ledger.dart';
import 'package:nilesoft_erp/layers/presentation/pages/ledger/bloc/ledger_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/ledger/bloc/ledger_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/ledger/bloc/ledger_state.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nilesoft_erp/layers/presentation/pages/share_document/share_ledger.dart';

String fromDate = "";
String toDate = "";
List<CustomersModel> customers = [];
CustomersModel? selectedCustomer;
String openbal = "0";
String debit = "0";
String credit = "0";
String currentbal = "0";
List<LedgerModel> ledgers = [];
int numberOfRows = 0;
int recievedLen = 0;
bool isPaginationComplete = false;
bool isPaginationLoading = false;

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LedgerBloc>();
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return PopScope(
      onPopInvoked: (didPop) {
        fromDate = "";
        toDate = "";
        customers = [];
        selectedCustomer = null;
        openbal = "0";
        debit = "0";
        credit = "0";
        currentbal = "0";
        ledgers = [];
        numberOfRows = 0;
        recievedLen = 0;
        isPaginationComplete = false;
        isPaginationLoading = false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<LedgerBloc, LedgerState>(
                builder: (context, state) {
                  // Check if share is allowed
                  bool canShare = ledgers.isNotEmpty &&
                      selectedCustomer != null &&
                      fromDate.isNotEmpty &&
                      toDate.isNotEmpty &&
                      isPaginationComplete &&
                      !isPaginationLoading;

                  return IconButton(
                    onPressed: canShare
                        ? () async {
                            try {
                              await generateAndShareLedgerPdf(
                                ledgers: ledgers,
                                customerName: selectedCustomer!.name ?? '',
                                fromDate: fromDate,
                                toDate: toDate,
                                openbal: openbal,
                                debit: debit,
                                credit: credit,
                                currentbal: currentbal,
                              );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'حدث خطأ أثناء مشاركة الملف: ${e.toString()}',
                                      style: const TextStyle(
                                          fontFamily: 'Almarai'),
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          }
                        : () {
                            String message = '';
                            if (selectedCustomer == null) {
                              message = 'يرجى اختيار العميل أولاً';
                            } else if (fromDate.isEmpty || toDate.isEmpty) {
                              message = 'يرجى تحديد تاريخ البداية والنهاية';
                            } else if (ledgers.isEmpty) {
                              message = 'لا توجد بيانات للمشاركة';
                            } else if (isPaginationLoading) {
                              message =
                                  'جاري تحميل البيانات... يرجى الانتظار حتى اكتمال التحميل';
                            } else if (!isPaginationComplete) {
                              message =
                                  'جاري تحميل جميع البيانات... يرجى الانتظار';
                            } else {
                              message = 'يرجى تحديد البيانات أولاً';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  message,
                                  style: const TextStyle(fontFamily: 'Almarai'),
                                ),
                                backgroundColor: Colors.orange,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                    icon: isPaginationLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          )
                        : Icon(
                            Icons.share,
                            color: canShare ? Colors.blue : Colors.grey,
                          ),
                    tooltip: canShare
                        ? "مشاركة التقرير"
                        : isPaginationLoading
                            ? "جاري التحميل..."
                            : "يرجى الانتظار حتى اكتمال تحميل البيانات",
                  );
                },
              ),
              const Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "تقرير كشف حساب عميل",
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocConsumer<LedgerBloc, LedgerState>(
          listener: (BuildContext context, LedgerState state) {
            if (state is LedgerError) {
              // Reset pagination flags on error
              isPaginationLoading = false;
              isPaginationComplete = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage,
                    style: const TextStyle(fontFamily: 'Almarai'),
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
            
            if (state is LedgerPageChanged) {
              recievedLen += state.ledger.length;
              ledgers += state.ledger;
              isPaginationLoading = true;
              isPaginationComplete = false;

              if (ledgers.length != numberOfRows &&
                  ledgers.length == recievedLen) {
                // More pages to load
                LedgerParametersModel ledgerParam = LedgerParametersModel(
                  accid: selectedCustomer?.id,
                  firstrow: ledgers.length,
                  fromdate: fromDate,
                  todate: toDate,
                  openbal: ledgers.isNotEmpty ? ledgers.last.balance : 0,
                  type: "3",
                );
                bloc.add(OnLedgerPageChanged(ledgerParameters: ledgerParam));
              } else if (ledgers.length == numberOfRows) {
                // Pagination complete
                isPaginationLoading = false;
                isPaginationComplete = true;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم تحميل جميع البيانات بنجاح',
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            }

            if (state is LedgerSubmitted) {
              openbal = state.ledgerFirstRes.openbal.toString();
              debit = state.ledgerFirstRes.totalDebit.toString();
              credit = state.ledgerFirstRes.totalCridet.toString();
              currentbal = state.ledgerFirstRes.currentBalance.toString();
              numberOfRows = state.ledgerFirstRes.noofrows ?? 0;
              
              // Reset pagination flags
              isPaginationComplete = false;
              isPaginationLoading = false;
              recievedLen = 0;
              ledgers = [];

              if (numberOfRows == 0) {
                // No data to load
                isPaginationComplete = true;
                isPaginationLoading = false;
              } else if (ledgers.isEmpty) {
                // Start pagination
                isPaginationLoading = true;
                LedgerParametersModel ledgerParam = LedgerParametersModel(
                  accid: selectedCustomer?.id,
                  firstrow: 0,
                  fromdate: fromDate,
                  todate: toDate,
                  openbal: double.parse(openbal),
                  type: "3",
                );
                bloc.add(OnLedgerPageChanged(ledgerParameters: ledgerParam));
              }
            }

            if (state is LedgerLoaded) {
              customers = state.customers;
              selectedCustomer = state.selectedCustomer;
            }

            if (state is FromDateChanged) {
              fromDate = intl.DateFormat('yyyy-MM-dd').format(
                intl.DateFormat('yyyy-MM-dd').parse(state.date),
              );
            }

            if (state is ToDateChanged) {
              toDate = intl.DateFormat('yyyy-MM-dd').format(
                intl.DateFormat('yyyy-MM-dd').parse(state.date),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: width * 0.48,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "الي",
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              DatePickerField(
                                label: toDate.isEmpty ? "اختر التاريخ" : toDate,
                                onDateSelected: (val) {
                                  bloc.add(OnToDateChanged(date: val.toString()));
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.48,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "من",
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              DatePickerField(
                                label: fromDate.isEmpty ? "اختر التاريخ" : fromDate,
                                onDateSelected: (val) {
                                  bloc.add(OnFromDateChanged(date: val.toString()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      width: width * 0.97,
                      height: 57,
                      child: SearchableDropdown(
                        onSearch: (val) {},
                        customers: customers,
                        selectedCustomer: selectedCustomer,
                        onCustomerSelected: (value) {
                          if (value != null) {
                            selectedCustomer = value;
                            bloc.add(OnCustomerSelected(
                                selectedCustomer: value, customers: customers));
                          }
                        },
                        width: width,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      width: width * 0.96,
                      child: CustomButton(
                        text: "موافق",
                        onPressed: () {
                          LedgerParametersModel ledgerParam =
                              LedgerParametersModel(
                            accid: selectedCustomer?.id,
                            firstrow: 0,
                            fromdate: fromDate,
                            todate: toDate,
                            openbal: 0,
                            type: "3",
                          );
                          bloc.add(
                              OnLedgerSubmit(ledgerParameters: ledgerParam));
                        },
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 180.0),
                        child: ledgers.isEmpty && !isPaginationLoading
                            ? const Center(
                                child: Text(
                                  "لا توجد بيانات",
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: ledgers.length +
                                    (isPaginationLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == ledgers.length &&
                                      isPaginationLoading) {
                                    // Show loading indicator at the bottom
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 8),
                                            Text(
                                              "جاري تحميل البيانات...",
                                              style: TextStyle(
                                                fontFamily: 'Almarai',
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  final ledger = ledgers[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: LedgerInfoCard(
                                      date: ledger.docdate.toString(),
                                      docNumber: ledger.docno2.toString(),
                                      description: ledger.descr.toString(),
                                      debit: ledger.debit.toString(),
                                      credit: ledger.cridet.toString(),
                                      balance: ledger.balance.toString(),
                                    ),
                                  );
                                },
                              ),
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
                    child: SummaryLedgCard(
                      openbal: openbal,
                      credit: credit,
                      currentbal: currentbal,
                      debit: debit,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
