abstract class CashinPrevEvent {}

class OnCashInPreview extends CashinPrevEvent {}

class OnCashinPreviewSent extends CashinPrevEvent {}

class OnCashinPreviewUnsent extends CashinPrevEvent {}

//
class OnCashinDelete extends CashinPrevEvent {
  final int id;
  OnCashinDelete({required this.id});
}
