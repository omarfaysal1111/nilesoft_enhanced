import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/oval_button.dart';
import 'package:nilesoft_erp/layers/presentation/components/sqr_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/cashin_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_state.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/invoice_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                onClick: () {},
                height: 151,
                width: 164,
                img: "assets/preview.png",
                text: "استعراض \nالمستندات",
              ),
              SqrButton(
                onClick: () {},
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
                onClick: () {},
                height: 151,
                width: 164,
                img: "assets/addclient.png",
                text: "اضافة عميل",
              ),
              SqrButton(
                onClick: () {},
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
                    // if (state.isUpdateSubmitted) {
                    //  const CircularProgressIndicator();
                    // }
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
                    return OvalButton(
                        text: "تحديث",
                        onPressed: () {
                          homeBloc.add(UpdatingSumbittedEvent());
                        });
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  OvalButton(text: "ارسال", onPressed: () {}),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              SqrButton(
                onClick: () {},
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
