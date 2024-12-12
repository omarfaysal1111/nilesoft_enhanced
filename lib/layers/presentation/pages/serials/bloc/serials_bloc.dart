import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/serials_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/serials/bloc/serial_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/serials/bloc/serials_state.dart';

int serialsCount = 0;

class SerialsBloc extends Bloc<SerialEvent, SerialsState> {
  SerialsBloc() : super(SerialInitial()) {
    on<OnSerialInit>(_serialinit);
    on<OnSerialSubmitted>(_serialSubmitted);
  }
  void _serialinit(OnSerialInit event, Emitter<SerialsState> emit) {
    emit(SerialLoaded(invId: event.invId, len: event.lenOfSerials));
  }

  void _serialSubmitted(OnSerialSubmitted event, Emitter<SerialsState> emit) {
    SerialsRepoImpl serialsRepoImpl = SerialsRepoImpl();
    serialsRepoImpl.saveSerial(serial: event.serial);
    ++serialsCount;
    if (serialsCount == event.len) {
      emit(SerialsFinished());
    } else {
      emit(SerialSubmitted());
    }
  }
}
