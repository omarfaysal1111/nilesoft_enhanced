import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';

abstract class CashinEvent {}

class FetchCashinClientsEvent extends CashinEvent {}

class SaveCashinPressed extends CashinEvent {
  final CashinModel cashinModel;

  SaveCashinPressed({required this.cashinModel});
}

class OnCashinToEdit extends CashinEvent {
  final CashinModel cashinModel;
  final int id;

  OnCashinToEdit({
    required this.cashinModel,
    required this.id,
  });
}

class OnCashinUpdate extends CashinEvent {
  final CashinModel cashinModel;

  OnCashinUpdate({required this.cashinModel});
}
