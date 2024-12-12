import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';

class CashinPrevState {}

class CashinPrevInit extends CashinPrevState {}

class CashInPrevLoading extends CashinPrevState {}

class CashInPrevLoaded extends CashinPrevState {
  final List<CashinModel> cashinModel;

  CashInPrevLoaded({required this.cashinModel});
}
