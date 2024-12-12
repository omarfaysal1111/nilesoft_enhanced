class DeleteEvent {}

class OnDeleteInitial extends DeleteEvent {}

class OnDelete extends DeleteEvent {
  final String pass;

  OnDelete({required this.pass});
}
