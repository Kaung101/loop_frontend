import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/chat/chat_bloc.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/chat/direct_message_view.dart';
import 'package:loop/components/colors.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _CreateChatViewState();
}

class _CreateChatViewState extends State<ChatView> {
  List<Widget> _listTileBuilder(ChatState state) {
    return List.from(state.messages.keys.map(
      (userId) => ListTile(
          title: Text(userId.item2),
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: Text(userId.item2.substring(0, 2).toUpperCase(),
                style: const TextStyle(color: AppColors.backgroundColor)),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DirectMessageView(userId: userId)))),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: _listTileBuilder(state),
          ));
    });
  }
}
