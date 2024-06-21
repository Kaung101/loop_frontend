abstract class ChatEvent {}

class ChatUserLoggedIn extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String content;
  final String to;
  final String toUser;

  SendMessage({required this.content, required this.to, required this.toUser});
}

class SendMediaMessage extends ChatEvent {
  final String content;
  final String to;
  final String toUser;
  final String mimetype;

  SendMediaMessage(
      {required this.content,
      required this.to,
      required this.toUser,
      required this.mimetype});
}

class ReceiveMessage extends ChatEvent {
  final String content;
  final String from;
  final String fromUser;

  ReceiveMessage(
      {required this.content, required this.from, required this.fromUser});
}
