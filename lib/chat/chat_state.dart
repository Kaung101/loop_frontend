import 'package:tuple/tuple.dart';

enum MessageType { media, text }

class Message {
  String from = '';
  String fromUser = '';
  String to = '';
  MessageType type = MessageType.text;
  String content = '';
  String mimetype = '';
  DateTime? timestamp;

  Message({
    required this.to,
    required this.from,
    required this.fromUser,
    required this.content,
    required this.type,
    required this.mimetype,
    DateTime? timestamp,
  });

  Map<String, dynamic> toJson() => {
        'to': to,
        'from': from,
        'from_user': fromUser,
        'content': content,
        'type': type.name,
        'mimetype': mimetype,
      };
}

class ChatState {
  const ChatState({
    this.messages = const {},
    this.contacts = const [],
  });

  final Map<Tuple2<String, String>, List<Message>> messages;
  final List<Tuple2<String, String>> contacts;

  ChatState copyWith({
    Map<Tuple2<String, String>, List<Message>>? messages,
    List<Tuple2<String, String>>? contacts,
  }) {
    return ChatState(
        messages: messages ?? this.messages,
        contacts: contacts ?? this.contacts);
  }
}
