import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/remote_invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/remote_item_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_invoice_repo.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/components/sqr_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/add_customer.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/cashin_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/resales_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_state.dart';
import 'package:nilesoft_erp/layers/presentation/pages/delete_data/bloc/delete_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/delete_data/bloc/delete_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/delete_data/delete_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/invoice_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/ledger/bloc/ledger_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/ledger/bloc/ledger_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/ledger/ledger_screen.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/pages/main_preview_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/login_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/bloc/login_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nilesoft_erp/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Nilesoft",
              style:
                  TextStyle(fontFamily: "Almarai", fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      title: const Text(
                        "تسجيل الخروج",
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                      content: const Text(
                        "هل أنت متأكد من تسجيل الخروج؟",
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            "إلغاء",
                            style: TextStyle(fontFamily: 'Almarai'),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            "تسجيل الخروج",
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

              if (shouldLogout == true) {
                // Clear SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove("user_token");

                // Clear the token in MyApp
                MyApp.token = null;

                // Navigate to login page
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Provider<LoginBloc>(
                        create: (_) => LoginBloc(),
                        child: const LoginPage(),
                      ),
                    ),
                    (route) => false,
                  );
                }
              }
            },
            tooltip: "تسجيل الخروج",
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SqrButton(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) =>
                            CashinBloc()..add(FetchCashinClientsEvent()),
                        child: const CashinPage(),
                      ),
                    ),
                  );
                },
                height: 151,
                width: 164,
                img: "assets/mobilecash.png",
                text: "سند قبض نقدي",
              ),
              SqrButton(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) =>
                            InvoiceBloc()..add(InitializeDataEvent()),
                        child: const InvoicePage(
                          extraTitle: "المبيعات",
                          invoiceType: 1,
                        ),
                      ),
                    ),
                  );
                },
                height: 151,
                width: 164,
                img: "assets/invoice.png",
                text: "فاتورة المبيعات",
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SqrButton(
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPreviewPage(),
                      ));
                },
                height: 151,
                width: 164,
                img: "assets/preview.png",
                text: "استعراض \nالمستندات",
              ),
              SqrButton(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) =>
                            ResalesBloc()..add(ReInitializeDataEvent()),
                        child: const ResalesPage(),
                      ),
                    ),
                  );
                },
                height: 151,
                width: 164,
                img: "assets/resale.png",
                text: "مردودات \nالمبيعات",
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SqrButton(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) =>
                            AddCustomerBloc()..add(OnAddCustomerInit()),
                        child: const AddCustomer(),
                      ),
                    ),
                  );
                },
                height: 151,
                width: 164,
                img: "assets/addclient.png",
                text: "اضافة عميل",
              ),
              SqrButton(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) =>
                            LedgerBloc()..add(OnLedgerIntial()),
                        child: const LedgerScreen(),
                      ),
                    ),
                  );
                },
                height: 151,
                width: 164,
                img: "assets/rep.png",
                text: "تقرير كشف \nحساب عميل",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
                    // Show error message if present
                    if (state.errorMessage != null &&
                        !state.isUpdateSubmitted &&
                        !state.isSendingSubmitted) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.errorMessage!,
                              style: const TextStyle(fontFamily: 'Almarai'),
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      });
                    }
                  }, builder: (BuildContext context, HomeState state) {
                    if (state.isUpdateSubmitted) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("جاري تحديث البيانات"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                      return const CircularProgressIndicator();
                    }
                    if (state.isUpdateSucc) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم تحديث البيانات"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    }
                    if (state.isSendingSucc && !state.isSendingSubmitted) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        if (state.messages != null &&
                            state.messages!.isNotEmpty) {
                          // Show errors in a modal dialog that blocks all interactions
                          showDialog(
                            context: context,
                            barrierDismissible:
                                false, // Prevent dismissing by tapping outside
                            builder: (dialogContext) => WillPopScope(
                              onWillPop: () async =>
                                  false, // Prevent dismissing with back button
                              child: AlertDialog(
                                title: const Text(
                                  "تحذيرات",
                                  style: TextStyle(fontFamily: 'Almarai'),
                                ),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.messages!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          state.messages![index],
                                          style: const TextStyle(
                                            fontFamily: 'Almarai',
                                            color: Colors.orange,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text(
                                      "موافق",
                                      style: TextStyle(fontFamily: 'Almarai'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("تم ارسال البيانات بنجاح"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      });
                    } else if (!state.isSendingSubmitted &&
                        !state.isSendingSucc &&
                        state.messages != null &&
                        state.messages!.isNotEmpty) {
                      // Show errors in a modal dialog that blocks all interactions
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Prevent dismissing by tapping outside
                          builder: (dialogContext) => WillPopScope(
                            onWillPop: () async =>
                                false, // Prevent dismissing with back button
                            child: AlertDialog(
                              title: const Text(
                                "أخطاء في الإرسال",
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  color: Colors.red,
                                ),
                              ),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.messages!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        state.messages![index],
                                        style: const TextStyle(
                                          fontFamily: 'Almarai',
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text(
                                    "موافق",
                                    style: TextStyle(fontFamily: 'Almarai'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    }
                    return SizedBox(
                      width: 160,
                      child: CustomButton(
                          text: "تحديث",
                          onPressed: () {
                            homeBloc.add(UpdatingSumbittedEvent());
                          }),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      final isLoading = state.isSendingSubmitted;

                      return SizedBox(
                        width: 164,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  homeBloc.add(SenddingSumbittedEvent());
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff39B3BD),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  "ارسال",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SqrButton(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) =>
                            DeleteBloc()..add(OnDeleteInitial()),
                        child: const DeletePage(),
                      ),
                    ),
                  );
                },
                height: 151,
                width: 164,
                img: "assets/delete.png",
                text: "مسح كل البيانات",
              ),
            ],
          )
        ],
      ),
    );
  }
}
