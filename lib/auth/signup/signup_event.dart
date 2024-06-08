abstract class SignUpEvent {}

class SignUpUsernameChanged extends SignUpEvent {
  final String username;

  SignUpUsernameChanged({required this.username});
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged({required this.email});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({required this.password});
}

class SignUpConfirmPasswordChanged extends SignUpEvent {
  final String confirmPassword;

  SignUpConfirmPasswordChanged({required this.confirmPassword});
}

class SignUpSubmitted extends SignUpEvent {
  //redirect to login page
  
}
