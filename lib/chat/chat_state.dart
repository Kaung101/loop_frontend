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
  String? media;

  Message({
    required this.to,
    required this.from,
    required this.fromUser,
    required this.content,
    required this.type,
    required this.mimetype,
    this.media,
    DateTime? timestamp,
  });

  Map<String, dynamic> toJson() => {
        'to': to,
        'from': from,
        'from_user': fromUser,
        'content': content,
        'type': type.name,
        'mimetype': mimetype,
        'media': media ?? '',
      };
}

class ChatState {
  const ChatState({
    this.messages = const {},
    this.contacts = const [],
    this.chatHistory = const {},
  });

  final Map<Tuple2<String, String>, List<Message>> messages;
  final List<Tuple2<String, String>> contacts;
  final Map<Tuple2<String, String>, List<Message>> chatHistory;

  ChatState copyWith({
    Map<Tuple2<String, String>, List<Message>>? messages,
    List<Tuple2<String, String>>? contacts,
    Map<Tuple2<String, String>, List<Message>>? chatHistory,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      contacts: contacts ?? this.contacts,
      chatHistory: chatHistory ?? this.chatHistory,
    );
  }
}
