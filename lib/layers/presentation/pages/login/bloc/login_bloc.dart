import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/settings_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/settings_repo_impl.dart';
import 'package:nilesoft_erp/main.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>((event, emit) async {
      SettingsRepoImpl settingsRepo = SettingsRepoImpl();

      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('${MyApp.baseurl}users/authenticate'));
      request.body =
          json.encode({"Username": state.email, "Password": state.password});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonString = await response.stream.bytesToString();
        // print(jsonString);
        Map<String, dynamic> userMap = jsonDecode(jsonString);
        MyApp.tocken = userMap['jwtToken'];
        SettingsModel setting = SettingsModel(
            cashaccId: userMap["cashid"],
            coinPrice: "1",
            invId: userMap["invenid"],
            mobileUserId: userMap["mobileinvoiceid"].toString(),
            visaId: userMap["visaid"]);
        await settingsRepo.deleteSettings();
        await settingsRepo.addSettings(
            setting: setting, tableName: DatabaseConstants.settingsTable);
      }

      //await Future.delayed(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.copyWith(isSubmitting: false, isFailure: true));
      }
    });
  }
}
