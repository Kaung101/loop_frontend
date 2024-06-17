import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/chat/chat_repo.dart';
import 'package:loop/chat/chat_event.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/util/jwt.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepo;
  IO.Socket socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  ChatBloc({required this.chatRepo}) : super(const ChatState()) {
    socket.onConnect(_onConnect);

    socket.on('receive:message', _onSocketReceiveMessage);
    socket.on('receive:media_message', _onReceiveMediaMessage);

    on<UserLoggedIn>(_onUserLoggedIn);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onUserLoggedIn(
      UserLoggedIn event, Emitter<ChatState> emit) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwtToken');

    socket.io.options?['extraHeaders'] = {'authorization': 'bearer $token'};
    socket.connect();
  }

  void _onConnect(data) {}

  void _onReceiveMediaMessage(data) {}

  Future<void> _onReceiveMessage(
      ReceiveMessage event, Emitter<ChatState> emit) async {
    Map<String, List<Message>> originalMessages = Map.from(state.messages);
    if (!originalMessages.containsKey(event.from)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([MapEntry(event.from, emptyList)]);
    }

    final messagesOfUser = originalMessages[event.from];
    final messageToAdd = Message(
        to: await getUserId(),
        from: event.from,
        content: event.content,
        type: MessageType.text);

    messagesOfUser!.add(messageToAdd);

    emit(state.copyWith(
      messages: originalMessages,
    ));
  }

  void _onSocketReceiveMessage(data) {
    add(ReceiveMessage(content: data['content'], from: data['from']));
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    Map<String, List<Message>> originalMessages = Map.from(state.messages);
    if (!originalMessages.containsKey(event.to)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([MapEntry(event.to, emptyList)]);
    }

    final messagesOfUser = originalMessages[event.to];
    final messageToAdd = Message(
        from: await getUserId(),
        to: event.to,
        content: event.content,
        type: MessageType.text);
    messagesOfUser!.add(messageToAdd);

    emit(state.copyWith(
      messages: originalMessages,
    ));

    socket.emit('send:message', jsonEncode(messageToAdd));
  }
}
