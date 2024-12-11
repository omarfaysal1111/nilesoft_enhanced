import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  const LoginState({
    required this.email,
    required this.password,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.isFailure,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      isSubmitting: false,
      errorMessage: '',
      isSuccess: false,
      isFailure: false,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool? isFailure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? '',
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  List<Object> get props =>
      [email, password, isSubmitting, isSuccess, isFailure];
}
