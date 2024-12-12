import 'package:nilesoft_erp/layers/domain/models/serials_model.dart';

abstract class SerialEvent {}

class OnSerialInit extends SerialEvent {
  final int lenOfSerials;
  final String invId;

  OnSerialInit({required this.lenOfSerials, required this.invId});
}

class OnSerialSubmitted extends SerialEvent {
  final SerialsModel serial;
  final int len;
  OnSerialSubmitted({required this.serial, required this.len});
}
