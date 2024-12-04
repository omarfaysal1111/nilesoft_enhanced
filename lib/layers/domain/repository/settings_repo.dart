import 'package:nilesoft_erp/layers/data/models/settings_model.dart';

abstract class SettingsRepo {
  Future<SettingsModel> getSettings({required String tableName});
  Future<void> addSettings(
      {required SettingsModel setting, required String tableName});
  Future<void> deleteSettings();
}
