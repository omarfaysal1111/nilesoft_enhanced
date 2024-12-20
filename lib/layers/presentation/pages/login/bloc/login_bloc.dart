import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/settings_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/settings_repo_impl.dart';
import 'package:nilesoft_erp/main.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginSubmitted>((event, emit) async {
      String? identifier = await UniqueIdentifier.serial;
      SettingsRepoImpl settingsRepo = SettingsRepoImpl();

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${MyApp.baseurl}users/MobAuthenticate'));
      request.body = json.encode({
        "Username": event.email,
        "Password": event.password,
        "mobile_id": identifier
      });
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
        String jsonString = await response.stream.bytesToString();
        // print(jsonString);
        Map<String, dynamic> userMap = jsonDecode(jsonString);

        emit(state.copyWith(
            isSubmitting: false,
            isFailure: true,
            errorMessage: userMap["message"]));
      }
    });
  }
}
