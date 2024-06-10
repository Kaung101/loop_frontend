import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/post_management/create_post_event.dart';
import 'package:loop/post_management/create_post_form_status.dart';
import 'package:loop/post_management/create_post_state.dart';
import 'package:loop/post_management/post_repo.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository postRepo;

  CreatePostBloc({required this.postRepo}) : super(CreatePostState()) {
    on<CreatePostNameChanged>(_onNameChanged);
    on<CreatePostPriceChanged>(_onPriceChanged);
    on<CreatePostDescChanged>(_onDescChanged);
    on<PostSubmitted>(_onSubmitted);
  }

  void _onNameChanged(CreatePostNameChanged event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onPriceChanged(CreatePostPriceChanged event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(price: event.price));
  }

  void _onDescChanged(CreatePostDescChanged event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(PostSubmitted event, Emitter<CreatePostState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await postRepo.createPost(name: state.name, price: state.price, description: state.description);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on Exception catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e), errorMessage: e.toString()));
    }
  }
  
}