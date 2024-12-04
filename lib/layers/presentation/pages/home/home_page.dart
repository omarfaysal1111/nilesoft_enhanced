import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nilesoft_erp/layers/presentation/components/oval_button.dart';
import 'package:nilesoft_erp/layers/presentation/components/sqr_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Nilesoft",
          style: TextStyle(fontFamily: "Almarai", fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SqrButton(
                onClick: () {},
                height: 151,
                width: 164,
                img: "assets/mobilecash.png",
                text: "سند قبض نقدي",
              ),
              SqrButton(
                onClick: () {},
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
              OvalButton(text: "تحديث", onPressed: () {}),
              SizedBox(
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
