import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';

abstract class PreviewState {}

class DocPreviewInitial extends PreviewState {}

class DocPreviewLoading extends PreviewState {}

class DocPreviewLoaded extends PreviewState {
  final List<SalesHeadModel> salesModel;

  DocPreviewLoaded({required this.salesModel});
}

class DocPreviewSentLoaded extends PreviewState {
  final List<SalesHeadModel> salesModel;

  DocPreviewSentLoaded({required this.salesModel});
}

class DocPreviewUnsentLoaded extends PreviewState {
  final List<SalesHeadModel> salesModel;

  DocPreviewUnsentLoaded({required this.salesModel});
}
