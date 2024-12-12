import 'package:flutter/material.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/bloc/login_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static String baseurl = "http://api.alfaysalerp.com/";
  // static String baseurl = "http://192.168.1.27:7000/";
  static String? tocken;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nile Soft ERP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: SalesPreviewPage(),
      home: Provider<LoginBloc>(
        create: (_) => LoginBloc(),
        child: const LoginPage(),
      ),
    );
  }
}
