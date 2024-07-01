import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop/chat/chat_repo.dart';
import 'package:loop/chat/chat_event.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/util/jwt.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tuple/tuple.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  IO.Socket socket = IO.io(
      'http://54.254.8.87:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  ChatBloc({required this.chatRepository}) : super(const ChatState()) {
    socket.onConnect(_onConnect);

    socket.on('receive:message', _onSocketReceiveMessage);
    socket.on('receive:media_message', _onSocketReceiveMediaMessage);

    on<ChatUserLoggedIn>(_onUserLoggedIn);
    on<SendMessage>(_onSendMessage);
    on<SendMediaMessage>(_onSendMediaMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<ReceiveMediaMessage>(_onReceiveMediaMessage);
    on<ReadyToFetchContacts>(_onReadyToFetchContacts);
    on<FetchChatHistory>(_onFetchChatHistory);
    on<ClearBuffer>(_onClearBuffer);
  }

  Future<void> _onClearBuffer(ClearBuffer event, Emitter<ChatState> emit) async {
    emit(state.copyWith(messages: {}));
  }

  Future<void> _onFetchChatHistory(
      FetchChatHistory event, Emitter<ChatState> emit) async {
    final messages = await chatRepository.fetchChatHistory(event.userId);
    final key = Tuple2<String, String>(event.userId, event.userName);
    Map<Tuple2<String, String>, List<Message>> originalMessages =
        Map.from(state.chatHistory);
    if (!originalMessages.containsKey(key)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([MapEntry(key, emptyList)]);
    }
    // final messagesOfUser = originalMessages[key];
    // messagesOfUser = messages;
    originalMessages[key] = messages;
    emit(state.copyWith(chatHistory: originalMessages));
  }

  Future<void> _onReadyToFetchContacts(
      ReadyToFetchContacts event, Emitter<ChatState> emit) async {
    final contacts = await chatRepository.fetchContacts();
    emit(state.copyWith(contacts: contacts));
  }

  Future<void> _onUserLoggedIn(
      ChatUserLoggedIn event, Emitter<ChatState> emit) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwtToken');

    socket.io.options?['extraHeaders'] = {'authorization': 'bearer $token'};
    socket.connect();
  }

  void _onConnect(data) {}

  Future<void> _onReceiveMediaMessage(
      ReceiveMediaMessage event, Emitter<ChatState> emit) async {
    Map<Tuple2<String, String>, List<Message>> originalMessages =
        Map.from(state.messages);
    final key = Tuple2<String, String>(event.from, event.fromUser);
    if (!originalMessages.containsKey(key)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([
        MapEntry(Tuple2.fromList([event.from, event.fromUser]), emptyList)
      ]);
    }

    final messagesOfUser =
        originalMessages[Tuple2.fromList([event.from, event.fromUser])];
    final messageToAdd = Message(
        to: await getUserId(),
        from: event.from,
        fromUser: event.fromUser,
        content: event.content,
        mimetype: '',
        type: MessageType.values.byName(event.type));

    messagesOfUser!.add(messageToAdd);

    if (!state.contacts.contains(key)) {
      emit(state.copyWith(
        messages: originalMessages,
        contacts: [...state.contacts, key],
      ));
    } else {
      emit(state.copyWith(
        messages: originalMessages,
      ));
    }
  }

  Future<void> _onReceiveMessage(
      ReceiveMessage event, Emitter<ChatState> emit) async {
    Map<Tuple2<String, String>, List<Message>> originalMessages =
        Map.from(state.messages);
    final key = Tuple2<String, String>(event.from, event.fromUser);
    if (!originalMessages.containsKey(key)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([
        MapEntry(Tuple2.fromList([event.from, event.fromUser]), emptyList)
      ]);
    }

    final messagesOfUser =
        originalMessages[Tuple2.fromList([event.from, event.fromUser])];
    final messageToAdd = Message(
        to: await getUserId(),
        from: event.from,
        fromUser: event.fromUser,
        content: event.content,
        mimetype: '',
        type: MessageType.values.byName(event.type));

    messagesOfUser!.add(messageToAdd);

    if (!state.contacts.contains(key)) {
      emit(state.copyWith(
        messages: originalMessages,
        contacts: [...state.contacts, key],
      ));
    } else {
      emit(state.copyWith(
        messages: originalMessages,
      ));
    }
  }

  void _onSocketReceiveMessage(data) {
    add(ReceiveMessage(
      content: data['content'],
      from: data['from'],
      fromUser: data['from_user'],
      type: data['type'],
    ));
  }

  void _onSocketReceiveMediaMessage(data) {
    add(ReceiveMediaMessage(
      content: data['content'],
      from: data['from'],
      fromUser: data['from_user'],
      type: data['type'],
    ));
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    Map<Tuple2<String, String>, List<Message>> originalMessages =
        Map.from(state.messages);

    final key = Tuple2<String, String>(event.to, event.toUser);
    if (!originalMessages.containsKey(key)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([MapEntry(key, emptyList)]);
    }

    final messagesOfUser = originalMessages[key];
    final messageToAdd = Message(
        from: '',
        // server will read jwt token and add the info
        fromUser: '',
        // server will read jwt token and add the info
        to: event.to,
        content: event.content,
        mimetype: '',
        type: MessageType.text);

    messagesOfUser!.add(messageToAdd);

    emit(state.copyWith(
      messages: originalMessages,
    ));

    socket.emit('send:message', jsonEncode(messageToAdd));
  }

  Future<void> _onSendMediaMessage(
      SendMediaMessage event, Emitter<ChatState> emit) async {
    Map<Tuple2<String, String>, List<Message>> originalMessages =
        Map.from(state.messages);

    final key = Tuple2<String, String>(event.to, event.toUser);
    if (!originalMessages.containsKey(key)) {
      List<Message> emptyList = [];
      originalMessages.addEntries([MapEntry(key, emptyList)]);
    }

    final messagesOfUser = originalMessages[key];
    final messageToAdd = Message(
        from: '',
        // server will read jwt token and add the info
        fromUser: '',
        // server will read jwt token and add the info
        to: event.to,
        content: event.content,
        mimetype: event.mimetype,
        type: MessageType.media);

    messagesOfUser!.add(messageToAdd);

    emit(state.copyWith(
      messages: originalMessages,
    ));

    socket.emit('send:media_message', json.encode(messageToAdd));
  }
}
