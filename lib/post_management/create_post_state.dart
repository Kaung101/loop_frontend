import 'package:image_picker/image_picker.dart';
import 'package:loop/post_management/create_post_form_status.dart';

class CreatePostState {
  bool status;
  final String name;
  final String price;
  final String description;
  final FormSubmissionStatus formStatus;
  String errorMessage;
  XFile? beforePhoto;
  XFile? afterPhoto;

  CreatePostState({
    this.status = false,
    this.name = '',
    this.price = '',
    this.description = '',
    this.formStatus = const InitialFormStatus(),
    this.errorMessage = '',
    this.afterPhoto,
    this.beforePhoto,
  });

  CreatePostState copyWith({
    bool? status,
    String? name,
    String? price,
    String? description,
    FormSubmissionStatus? formStatus,
    String? errorMessage,
    XFile? beforePhoto,
    XFile? afterPhoto,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      beforePhoto: beforePhoto ?? this.beforePhoto,
      afterPhoto: afterPhoto ?? this.afterPhoto,
    );
  }
}
