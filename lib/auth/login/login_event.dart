// login_event.dart
abstract class LoginEvent {}

class LoginemailChanged extends LoginEvent {
  final String email;

  LoginemailChanged({required this.email});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged({required this.password});
}

class LoginSubmitted extends LoginEvent {}
