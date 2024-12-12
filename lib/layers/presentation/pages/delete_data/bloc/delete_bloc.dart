import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/presentation/pages/delete_data/bloc/delete_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/delete_data/bloc/delete_state.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  DeleteBloc() : super(DeleteInit()) {
    on<OnDeleteInitial>(
      (event, emit) {},
    );
    on<OnDelete>(_onDelete);
  }
  Future<void> _onDelete(OnDelete event, Emitter<DeleteState> emit) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    DatabaseConstants.startDB(databaseHelper);
    if (event.pass == "dtl9090") {
      await databaseHelper.deleteData();
      emit(DeleteSucc());
    }
    emit(DeleteFailed(txt: "خطأ بكلمة السر"));
  }
}
