import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/chat/chat_repo.dart';
import 'package:loop/chat/chat_event.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/util/jwt.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tuple/tuple.dart';

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
    Map<Tuple2<String, String>, List<Message>> originalMessages = Map.from(state.messages);
    final key = Tuple2<String, String>(event.from, event.fromUser);
    if (!originalMessages.containsKey(key)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([MapEntry(Tuple2.fromList([event.from, event.fromUser]), emptyList)]);
    }

    final messagesOfUser = originalMessages[Tuple2.fromList([event.from, event.fromUser])];
    final messageToAdd = Message(
        to: await getUserId(),
        from: event.from,
        fromUser: event.fromUser,
        content: event.content,
        type: MessageType.text);

    messagesOfUser!.add(messageToAdd);

    emit(state.copyWith(
      messages: originalMessages,
    ));
  }

  void _onSocketReceiveMessage(data) {
    add(ReceiveMessage(
        content: data['content'],
        from: data['from'],
        fromUser: data['from_user']));
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    Map<Tuple2<String, String>, List<Message>> originalMessages = Map.from(state.messages);

    final key = Tuple2<String, String>(event.to, event.toUser);
    if (!originalMessages.containsKey(key)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([MapEntry(key, emptyList)]);
    }

    final messagesOfUser = originalMessages[key];
    final messageToAdd = Message(
        from: '',                             // server will read jwt token and add the info
        fromUser: '',                         // server will read jwt token and add the info
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
