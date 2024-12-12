import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_card.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/pages/cashin_preview_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/pages/resales_preview_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/pages/sales_preview_page.dart';

class MainPreviewPage extends StatelessWidget {
  const MainPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                "استعراض المستندات",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) =>
                              PreviewBloc()..add(OnPreviewInitial()),
                          child: const SalesPreviewPage(),
                        ),
                      ),
                    );
                  },
                  child: const RectCard(
                      text: "فواتير المبيعات", icon: "assets/invoice.png"),
                )),
            SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) =>
                              RePreviewBloc()..add(ReOnPreviewInitial()),
                          child: const ReSalesPreviewPage(),
                        ),
                      ),
                    );
                  },
                  child: const RectCard(
                      text: "مردودات المبيعات", icon: "assets/resale.png"),
                )),
            SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) =>
                              CashinPrevBloc()..add(OnCashInPreview()),
                          child: const CashinPreviewPage(),
                        ),
                      ),
                    );
                  },
                  child: const RectCard(
                      text: "سندات القبض النقدي",
                      icon: "assets/mobilecash.png"),
                )),
            const Text(
              "تنبيه: المستندات المرسلة مسبقا لا يمكن تعديلها",
              style:
                  TextStyle(fontFamily: 'Almarai', fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}
