import 'package:nilesoft_erp/layers/domain/models/settings_model.dart';

abstract class SettingsRepo {
  Future<List<SettingsModel>> getSettings({required String tableName});
  Future<void> addSettings(
      {required SettingsModel setting, required String tableName});
  Future<void> deleteSettings();
}
