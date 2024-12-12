import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/add_customer.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_state.dart';

final name = TextEditingController();
final phone = TextEditingController();
final address = TextEditingController();

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    final bloc = context.read<AddCustomerBloc>();

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
                  "اضافة عميل",
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
        body: BlocConsumer<AddCustomerBloc, AddCustomerState>(
          listener: (BuildContext context, AddCustomerState state) {
            if (state is AddCustomerSucc) {
              name.text = "";
              phone.text = "";
              address.text = "";

              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تمت اضافة العميل"),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, AddCustomerState state) {
            if (state is AddCustomerInit) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: w / 1.1,
                        height: h / 20,
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: CustomTextField(
                              hintText: "اسم العميل",
                              onChanged: (val) {},
                              controller: name,
                            )),
                      ),
                      SizedBox(
                        height: h / 20,
                      ),
                      SizedBox(
                        width: w / 1.1,
                        height: h / 20,
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: CustomTextField(
                              hintText: "العنوان",
                              onChanged: (val) {},
                              controller: address,
                            )),
                      ),
                      SizedBox(
                        height: h / 20,
                      ),
                      SizedBox(
                        width: w / 1.1,
                        height: h / 20,
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: CustomTextField(
                              hintText: "رقم الهاتف",
                              onChanged: (val) {},
                              controller: phone,
                            )),
                      ),
                      SizedBox(
                        height: h / 20,
                      ),
                      SizedBox(
                        width: w * 0.96,
                        child: CustomButton(
                            text: "اضافة العميل",
                            onPressed: () {
                              AddCustomerModel addClientModel =
                                  AddCustomerModel(
                                      address: address.text,
                                      phone1: phone.text,
                                      name: name.text);
                              bloc.add(
                                  OnAddCustomer(customerModel: addClientModel));
                            }),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
