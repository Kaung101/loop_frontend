abstract class ChatEvent {}

class ChatUserLoggedIn extends ChatEvent {}

class ReadyToFetchContacts extends ChatEvent {}

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
  final String type;

  ReceiveMessage(
      {required this.content,
      required this.from,
      required this.fromUser,
      required this.type});
}

class ReceiveMediaMessage extends ChatEvent {
  final String content;
  final String from;
  final String fromUser;
  final String type;

  ReceiveMediaMessage(
      {required this.content,
      required this.from,
      required this.fromUser,
      required this.type});
}

class FetchChatHistory extends ChatEvent {
  final String userId;
  final String userName;

  FetchChatHistory({required this.userId, required this.userName});
}
