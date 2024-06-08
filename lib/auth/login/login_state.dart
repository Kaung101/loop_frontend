import 'package:loop/auth/loginform_status.dart';

class LoginState {
  final String email;
  final String password;
  final FormSubmissionStatus formStatus;
   String errorMessage;

  // Validate email and password
  bool get isValidEmail => email.contains(RegExp(r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+"));
  bool get isValidPassword => password.length >= 6;

  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
    this.errorMessage = '',
  });

  LoginState copyWith({
    String? email ,
    String? password ,
    FormSubmissionStatus? formStatus,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
