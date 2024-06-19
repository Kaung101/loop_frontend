abstract  class ChatEvent {}

class UserLoggedIn extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String content;
  final String to;
  final String toUser;

  SendMessage({ required this.content, required this.to, required this.toUser });
}

class ReceiveMessage extends ChatEvent {
  final String content;
  final String from;
  final String fromUser;

  ReceiveMessage({ required this.content, required this.from, required this.fromUser });
}