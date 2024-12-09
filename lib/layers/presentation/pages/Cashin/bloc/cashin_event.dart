import 'package:nilesoft_erp/layers/data/models/cashin_model.dart';

abstract class CashinEvent {}

class FetchCashinClientsEvent extends CashinEvent {}

class SaveCashinPressed extends CashinEvent {
  final CashinModel cashinModel;

  SaveCashinPressed({required this.cashinModel});
}
