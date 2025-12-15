import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/settings_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/settings_repo_impl.dart';
import 'package:nilesoft_erp/main.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(
          isSubmitting: true, isFailure: false, isSuccess: false));

      try {
        String? identifier = await UniqueIdentifier.serial;
        SettingsRepoImpl settingsRepo = SettingsRepoImpl();

        var headers = {'Content-Type': 'application/json'};
        var request = http.Request(
          'POST',
          Uri.parse('${MyApp.baseurl}users/MobAuthenticate'),
        );
        request.body = json.encode({
          "Username": event.email,
          "Password": event.password,
          "mobile_id": identifier
        });
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        String jsonString = await response.stream.bytesToString();
        
        // Check status code first
        if (response.statusCode != 200) {
          // If not 200, check if response is HTML error page
          if (jsonString.trim().startsWith('<!DOCTYPE') || 
              jsonString.trim().startsWith('<html') ||
              jsonString.trim().startsWith('<HTML')) {
            emit(state.copyWith(
              isSubmitting: false,
              isFailure: true,
              errorMessage: "خطأ في الاتصال بالخادم (${response.statusCode}). يرجى التحقق من عنوان الخادم.",
            ));
            return;
          }
        }
        
        // Check if response is actually JSON (not HTML error page)
        if (!jsonString.trim().startsWith('{') && !jsonString.trim().startsWith('[')) {
          emit(state.copyWith(
            isSubmitting: false,
            isFailure: true,
            errorMessage: "خطأ في الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت.",
          ));
          return;
        }

        Map<String, dynamic> userMap;
        try {
          userMap = jsonDecode(jsonString);
        } catch (e) {
          emit(state.copyWith(
            isSubmitting: false,
            isFailure: true,
            errorMessage: "خطأ في معالجة الاستجابة من الخادم: ${e.toString()}",
          ));
          return;
        }

        if (response.statusCode == 200) {
          // حفظ التوكن في MyApp و SharedPreferences
          String token = userMap['jwtToken'];
          MyApp.token = token;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_token", token);

          // حفظ باقي البيانات في SQLite
          // Safely access multiunit from mysetting object
          bool multiunitValue = false;
          try {
            if (userMap.containsKey("mysetting") && 
                userMap["mysetting"] != null && 
                userMap["mysetting"] is Map<String, dynamic>) {
              final mysetting = userMap["mysetting"] as Map<String, dynamic>;
              final multiunit = mysetting["multiunit"];
              multiunitValue = multiunit == true || 
                              multiunit == 1 || 
                              multiunit == "true" ||
                              multiunit == "1";
            }
          } catch (e) {
            // If mysetting doesn't exist or is not a Map, default to false
            if (kDebugMode) {
              print("Error accessing mysetting.multiunit: $e");
            }
          }
          
          SettingsModel setting = SettingsModel(
            cashaccId: userMap["cashid"],
            coinPrice: "1",
            invId: userMap["invenid"],
            mobileUserId: userMap["mobileinvoiceid"].toString(),
            visaId: userMap["visaid"],
            multiunit: multiunitValue,
          );

          await settingsRepo.deleteSettings();
          await settingsRepo.addSettings(
            setting: setting,
            tableName: DatabaseConstants.settingsTable,
          );

          emit(state.copyWith(
            isSubmitting: false,
            isSuccess: true,
            token: token,
          ));
        } else {
          emit(state.copyWith(
            isSubmitting: false,
            isFailure: true,
            errorMessage: userMap["message"] ?? "Login failed",
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          isFailure: true,
          errorMessage: "حدث خطأ: ${e.toString()}",
        ));
      }
    });
  }
}
