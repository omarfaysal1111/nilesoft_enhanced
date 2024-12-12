import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';

abstract class RePreviewState {}

class ReDocPreviewInitial extends RePreviewState {}

class ReDocPreviewLoading extends RePreviewState {}

class ReDocPreviewLoaded extends RePreviewState {
  final List<SalesHeadModel> salesModel;

  ReDocPreviewLoaded({required this.salesModel});
}
