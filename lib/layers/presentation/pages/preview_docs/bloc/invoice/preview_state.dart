import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';

abstract class PreviewState {}

class DocPreviewInitial extends PreviewState {}

class DocPreviewLoading extends PreviewState {}

class DocPreviewLoaded extends PreviewState {
  final List<SalesHeadModel> salesModel;

  DocPreviewLoaded({required this.salesModel});
}
