import 'package:nilesoft_erp/layers/domain/models/serials_model.dart';

abstract class RemoteSerialsRepo {
  Future<void> sendSerials(List<SerialsModel> serials);
}
