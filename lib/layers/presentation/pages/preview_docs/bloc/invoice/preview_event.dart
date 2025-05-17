abstract class PreviewEvent {}

class OnPreviewInitial extends PreviewEvent {}

class OnPreviewSent extends PreviewEvent {}

class OnPreviewUnsent extends PreviewEvent {}

class OnInvoiceDelete extends PreviewEvent {
  final int id;
  OnInvoiceDelete({required this.id});
}
