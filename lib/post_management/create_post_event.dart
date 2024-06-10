abstract class CreatePostEvent {}

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

class PostSubmitted extends CreatePostEvent {}