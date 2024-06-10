
import 'package:loop/post_management/create_post_form_status.dart';

class CreatePostState {
  final String name;
  final String price;
  final String description;
  final FormSubmissionStatus formStatus;
  String errorMessage;

  CreatePostState ({
    this.name = '',
    this.price = '',
    this.description = '',
    this.formStatus = const InitialFormStatus(),
    this.errorMessage = '',
  });

  CreatePostState copyWith({
    String? name ,
    String? price ,
    String? description,
    FormSubmissionStatus? formStatus,
    String? errorMessage,
  }) {
    return CreatePostState(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}