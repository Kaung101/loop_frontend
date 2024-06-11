import 'package:image_picker/image_picker.dart';

abstract class CreatePostEvent {}

class PostStatusChanged extends CreatePostEvent {
  final bool status;

  PostStatusChanged({ required this.status });
}

class CreatePostNameChanged extends CreatePostEvent {
  final String name;

  CreatePostNameChanged({ required this.name });
}

class CreatePostPriceChanged extends CreatePostEvent {
  final String price;

  CreatePostPriceChanged({ required this.price });
}

class CreatePostDescChanged extends CreatePostEvent {
  final String description;

  CreatePostDescChanged({ required this.description });
}

class BeforePhotoChanged extends CreatePostEvent {
  final XFile beforePhoto;

  BeforePhotoChanged({ required this.beforePhoto });
}

class AfterPhotoChanged extends CreatePostEvent {
  final XFile afterPhoto;

  AfterPhotoChanged({ required this.afterPhoto });
}

class PostSubmitted extends CreatePostEvent {}