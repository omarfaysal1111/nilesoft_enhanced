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

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LedgerBloc>();
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).width;

    return PopScope(
      // ignore: deprecated_member_use
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
                    "تقرير كشف حساب عميل",
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
          body: BlocConsumer<LedgerBloc, LedgerState>(
            listener: (BuildContext context, LedgerState state) {
              if (state is LedgerPageChanged) {
                recievedLen += state.ledger.length;
                ledgers += state.ledger;
                if (ledgers.length != numberOfRows) {
                  if (ledgers.length == recievedLen) {
                    LedgerParametersModel ledgerParam = LedgerParametersModel(
                        accid: selectedCustomer?.id,
                        firstrow: ledgers.length,
                        fromdate: fromDate,
                        todate: toDate,
                        openbal: ledgers[ledgers.length].balance,
                        type: "3");
                    bloc.add(
                        OnLedgerPageChanged(ledgerParameters: ledgerParam));
                  }
                }
              }
              if (state is LedgerSubmitted) {
                openbal = state.ledgerFirstRes.openbal.toString();
                debit = state.ledgerFirstRes.totalDebit.toString();
                credit = state.ledgerFirstRes.totalCridet.toString();
                currentbal = state.ledgerFirstRes.currentBalance.toString();
                numberOfRows = state.ledgerFirstRes.noofrows ?? 0;

                if (ledgers.isEmpty) {
                  LedgerParametersModel ledgerParam = LedgerParametersModel(
                      accid: selectedCustomer?.id,
                      firstrow: 0,
                      fromdate: fromDate,
                      todate: toDate,
                      openbal: double.parse(openbal),
                      type: "3");
                  bloc.add(OnLedgerPageChanged(ledgerParameters: ledgerParam));
                }
              }
              if (state is LedgerLoaded) {
                customers = state.customers;
                selectedCustomer = state.selectedCustomer;
              }
              if (state is FromDateChanged) {
                DateTime parsedDate =
                    intl.DateFormat('yyyy-MM-dd').parse(state.date);
                String formattedDate =
                    intl.DateFormat('yyyy-MM-dd').format(parsedDate);
                fromDate = formattedDate;
              }

              if (state is ToDateChanged) {
                DateTime parsedDate =
                    intl.DateFormat('yyyy-MM-dd').parse(state.date);
                String formattedDate =
                    intl.DateFormat('yyyy-MM-dd').format(parsedDate);
                toDate = formattedDate;
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: width * 0.48,
                              child: DatePickerField(
                                  label: toDate,
                                  onDateSelected: (val) {
                                    bloc.add(
                                        OnToDateChanged(date: val.toString()));
                                  })),
                          SizedBox(
                              width: width * 0.48,
                              child: DatePickerField(
                                  label: fromDate,
                                  onDateSelected: (val) {
                                    bloc.add(OnFromDateChanged(
                                        date: val.toString()));
                                  })),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      SizedBox(
                        width: width * 0.97,
                        height: 57,
                        child: SearchableDropdown(
                          onSearch: (val) {},
                          customers: customers, // Pass the list of customers
                          selectedCustomer:
                              selectedCustomer, // The current selection
                          onCustomerSelected: (value) {
                            if (value != null) {
                              selectedCustomer = value;
                              bloc.add(CustomerSelectedEvent(
                                  selectedCustomer: value));
                            }
                          },
                          width: width, // Pass the width for layout
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
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
                                      type: "3");
                              bloc.add(OnLedgerSubmit(
                                  ledgerParameters: ledgerParam));
                            }),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 180.0),
                          child: ListView.builder(
                            itemCount: ledgers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LedgerInfoCard(
                                    date: ledgers[index].docdate.toString(),
                                    docNumber: ledgers[index].docno2.toString(),
                                    description:
                                        ledgers[index].descr.toString(),
                                    debit: ledgers[index].debit.toString(),
                                    credit: ledgers[index].cridet.toString(),
                                    balance: ledgers[index].balance.toString()),
                              );
                            },
                          ),
                        ),
                      )
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
          )),
    );
  }
}
