import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/login/login_event.dart';
import 'package:loop/auth/login/login_state.dart';
import 'package:loop/auth/loginform_status.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo}) : super(LoginState()) {
    on<LoginemailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginemailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await authRepo.login(email: state.email, password: state.password);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on Exception catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e), errorMessage: e.toString()));
    }
  }
}

