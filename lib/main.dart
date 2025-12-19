import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/bloc/login_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/login/login_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString("user_token");

  runApp(MyApp(savedToken: savedToken));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.savedToken});

  static String baseurl = "http://api.alfaysalerp.com/";
  //static String baseurl = "http://192.168.1.17:7000/";

  static String? token;

  final String? savedToken;

  @override
  Widget build(BuildContext context) {
    token = savedToken; // نخزن التوكن في المتغير الستاتيك

    return MaterialApp(
      title: 'Nile Soft ERP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: token == null
          ? Provider<LoginBloc>(
              create: (_) => LoginBloc(),
              child: const LoginPage(),
            )
          : BlocProvider(
              create: (_) => HomeBloc(),
              child: const HomePage(),
            ),
    );
  }
}
