import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_card.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/preview_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/preview_state.dart';
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
                        child: const SalesPreviewPage(
                         
                        ),
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
                  onTap: () {},
                  child: const RectCard(
                      text: "مردودات المبيعات", icon: "assets/resale.png"),
                )),
            SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: GestureDetector(
                  onTap: () {},
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
