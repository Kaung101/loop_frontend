import 'package:loop/auth/loginform_status.dart';

class SignUpState {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final FormSubmissionStatus formStatus;
  String errorMessage;

  SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formStatus = const InitialFormStatus(),
    this.errorMessage = '',
  });

  bool get isValidUsername => username.length > 3;
  bool get isValidEmail => email.contains(RegExp(r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+"));
  bool get isValidPassword => password.contains(RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$"));
  bool get isPasswordMatch => password == confirmPassword;

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    FormSubmissionStatus? formStatus, 
    String? errorMessage = '',
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
