class DeleteState {}

class DeleteInit extends DeleteState {}

class DeleteSucc extends DeleteState {}

class DeleteFailed extends DeleteState {
  final String txt;

  DeleteFailed({required this.txt});
}
