import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/add_customer.dart';
import 'package:nilesoft_erp/layers/domain/models/city.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/cities_dropdown.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_state.dart';

final name = TextEditingController();
final phone = TextEditingController();
final address = TextEditingController();
final street = TextEditingController();
final responsiblePerson = TextEditingController();

CityModel? selectedArea;
CityModel? selectedCity;
CityModel? selectedGov;

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    // ignore: unused_local_variable
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
            responsiblePerson.text = "";
            if (state.msg == "0") {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تمت اضافة العميل"),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
              Navigator.pop(context);
            } else {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("اسم العميل مكرر"),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
            }
          }

          if (state is AreasLoaded) {
            selectedArea = state.selectedArea;
            selectedCity = state.selectedCity;
            selectedGov = state.selectedGov;
          }
        },
        builder: (BuildContext context, AddCustomerState state) {
          if (state is AreasLoaded) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Container(
                      width: w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "بيانات العميل",
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 16),
                          // اسم العميل
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "اسم العميل",
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: "اكتب اسم العميل",
                            onChanged: (val) {},
                            controller: name,
                          ),
                          const SizedBox(height: 16),
                          // المنطقة
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "المنطقة",
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CitiesDropdown(
                            onSearch: (val) {},
                            citys: state.areas,
                            selectedCity: state.selectedArea,
                            onCitySelected: (value) {
                              if (value != null) {
                                bloc.add(OnAreaSelected(selectedArea: value));
                              }
                            },
                            width: MediaQuery.of(context).size.width,
                            onCustomerSelected: (value) {},
                            lable: 'المنطقة',
                          ),
                          const SizedBox(height: 16),
                          // المدينة
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "المدينة",
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CitiesDropdown(
                            onSearch: (val) {},
                            citys: state.cities,
                            selectedCity: state.selectedCity,
                            onCitySelected: (value) {
                              if (value != null) {
                                bloc.add(OnCitySelected(selectedCity: value));
                              }
                            },
                            width: MediaQuery.of(context).size.width / 1.1,
                            onCustomerSelected: (value) {},
                            lable: 'المدينة',
                          ),
                          const SizedBox(height: 16),
                          // المحافظة
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "المحافظة",
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CitiesDropdown(
                            onSearch: (val) {},
                            citys: state.govs,
                            selectedCity: state.selectedGov,
                            onCitySelected: (value) {
                              if (value != null) {
                                bloc.add(OnGovSelected(selectedGov: value));
                              }
                            },
                            width: MediaQuery.of(context).size.width,
                            onCustomerSelected: (value) {},
                            lable: 'المحافظة',
                          ),
                          const SizedBox(height: 16),
                          // رقم الهاتف
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "رقم الهاتف",
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: "اكتب رقم الهاتف",
                            onChanged: (val) {},
                            controller: phone,
                          ),
                          const SizedBox(height: 16),
                          // العنوان
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "العنوان",
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: "اكتب العنوان",
                            onChanged: (val) {},
                            controller: address,
                          ),
                          const SizedBox(height: 16),
                          // الشارع
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "الشارع",
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: "اكتب اسم الشارع",
                            onChanged: (val) {},
                            controller: street,
                          ),
                          const SizedBox(height: 16),
                          // الشخص المسئول
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "الشخص المسئول",
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: "اكتب اسم الشخص المسئول",
                            onChanged: (val) {},
                            controller: responsiblePerson,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: "اضافة العميل",
                              onPressed: () {
                                if (selectedArea != null &&
                                    selectedCity != null &&
                                    selectedGov != null &&
                                    phone.text != "" &&
                                    street.text != "") {
                                  AddCustomerModel addClientModel =
                                      AddCustomerModel(
                                    address: address.text,
                                    phone1: phone.text,
                                    name: name.text,
                                    governmentid: selectedGov!.id.toString(),
                                    street: street.text,
                                    areaid: selectedArea!.id.toString(),
                                    cityid: int.parse(
                                      selectedCity!.id,
                                    ),
                                    responsiblePerson: responsiblePerson.text,
                                  );
                                  bloc.add(OnAddCustomer(
                                      customerModel: addClientModel));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("من فضلك اكمل جميع البيانات"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
