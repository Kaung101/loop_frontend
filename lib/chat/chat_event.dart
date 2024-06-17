abstract  class ChatEvent {}

class UserLoggedIn extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String content;
  final String to;

  SendMessage({ required this.content, required this.to });
}

class ReceiveMessage extends ChatEvent {
  final String content;
  final String from;

  ReceiveMessage({ required this.content, required this.from });
}