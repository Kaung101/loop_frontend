enum MessageType { media, text }

class Message {
  String from = '';
  String to = '';
  MessageType type = MessageType.text;
  String content = '';
  DateTime? timestamp;

  Message({
    required this.to,
    required this.from,
    required this.content,
    required this.type,
    DateTime? timestamp,
  });

  Map<String, dynamic> toJson() => {
    'to': to,
    'from': from,
    'content': content,
    'type': type.name,
  };
}

class ChatState {
// class ChatState extends Equatable {
  const ChatState({
    this.messages = const {},
  });

  final Map<String, List<Message>> messages;

  ChatState copyWith({
    Map<String, List<Message>>? messages,
  }) {
    return ChatState(messages: messages ?? this.messages);
  }

  // @override
  // List<Object> get props => [messages];
}
