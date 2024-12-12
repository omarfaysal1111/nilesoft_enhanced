class SerialsState {}

class SerialInitial extends SerialsState {}

class SerialLoaded extends SerialsState {
  final String invId;
  final int len;

  SerialLoaded({required this.invId, required this.len});
}

class SerialSubmitted extends SerialsState {
  SerialSubmitted();
}

class SerialsFinished extends SerialsState {}
