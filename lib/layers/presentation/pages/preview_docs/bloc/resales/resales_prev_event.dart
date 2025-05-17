abstract class RePreviewEvent {}

class ReOnPreviewInitial extends RePreviewEvent {}

class ReOnPreviewSent extends RePreviewEvent {}

class ReOnPreviewUnsent extends RePreviewEvent {}

class OnReInvoiceDelete extends RePreviewEvent {
  final int id;
  OnReInvoiceDelete({required this.id});
}
