
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/signup/signup_event.dart';
import 'package:loop/auth/signup/signup_state.dart';
import 'package:loop/auth/loginform_status.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepo;

  SignUpBloc({required this.authRepo}) : super(SignUpState()) {
    on<SignUpUsernameChanged>(_onUsernameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onUsernameChanged(SignUpUsernameChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onConfirmPasswordChanged(SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  Future<void> _onSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await authRepo.signUp(
        username: state.username,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on Exception catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e), errorMessage: e.toString()));
    }
  }
}
