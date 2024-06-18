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
// class ChatState extends Equatable {
  const ChatState({
    this.messages = const {},
  });

  final Map<Tuple2<String, String>, List<Message>> messages;

  ChatState copyWith({
    Map<Tuple2<String, String>, List<Message>>? messages,
  }) {
    return ChatState(messages: messages ?? this.messages);
  }

  // @override
  // List<Object> get props => [messages];
}
