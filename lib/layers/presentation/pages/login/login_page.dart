import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/home_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/bloc/login_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/bloc/login_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/bloc/login_state.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xff39B3BD),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: width,
            height: height * (595 / 852),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * (88 / 852),
                  ),
                  const Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w800,
                        fontSize: 28),
                  ),
                  SizedBox(
                    height: height * (118 / 852),
                  ),
                  SizedBox(
                    width: width * (353 / 393),
                    height: height * (56 / 852),
                    child: CustomTextField(
                      onChanged: (val) {},
                      hintText: "اسم المستخدم",
                      controller: emailController,
                    ),
                  ),
                  SizedBox(
                    height: height * (20 / 852),
                  ),
                  SizedBox(
                    width: width * (353 / 393),
                    height: height * (56 / 852),
                    child: CustomTextField(
                      onChanged: (val) {},
                      hintText: "كلمة السر",
                      controller: passwordController,
                    ),
                  ),
                  SizedBox(
                    height: height * (54 / 852),
                  ),
                  SizedBox(
                      width: width * (353 / 393),
                      height: height * (56 / 852),
                      child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                        if (state.isSuccess) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => HomeBloc(),
                                child: const HomePage(),
                              ),
                            ),
                          );
                        }
                      }, builder: (context, state) {
                        if (state.isSubmitting) {
                          return const SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator());
                        }
                        return CustomButton(
                            text: "تسجيل الدخول",
                            onPressed: () {
                              loginBloc.add(LoginSubmitted(
                                  email: emailController.text,
                                  password: passwordController.text));
                            });
                      }))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
