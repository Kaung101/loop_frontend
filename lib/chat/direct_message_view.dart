import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/chat/chat_bloc.dart';
import 'package:loop/chat/chat_event.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/chat/received_message_bubble.dart';
import 'package:loop/chat/sent_message_bubble.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/components/colors.dart';
import 'package:tuple/tuple.dart';

class DirectMessageView extends StatefulWidget {
  const DirectMessageView({super.key, required this.userId});

  final Tuple2<String, String> userId;

  @override
  State<DirectMessageView> createState() => _DirectMessageViewState();
}

class _DirectMessageViewState extends State<DirectMessageView> {
  final TextEditingController _chatInputController = TextEditingController();

  List<Widget> _buildMessage(ChatState state) {
    print(widget.userId);
    return List.from(state.messages[widget.userId]!.map((message) {
      if (message.from == widget.userId.item1) {
        return ReceivedMessageBubble(message: message.content);
      } else {
        return SentMessageBubble(message: message.content);
      }
    }));
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textColor),
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (context) => const BottomNav(),
              ),
            );
          },
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: Row(children: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    widget.userId.item2.substring(0, 2).toUpperCase(),
                    style: const TextStyle(color: AppColors.backgroundColor),
                  ),
                )),
            Text(widget.userId.item2)
          ]),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(child: ListView(children: _buildMessage(state))),
                TextField(
                  controller: _chatInputController,
                  decoration: InputDecoration(
                      fillColor: AppColors.backgroundColor,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                            color: AppColors.primaryColor,
                            icon: const Icon(Icons.image_outlined),
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.transparent;
                                  }
                                  if (states.contains(MaterialState.focused) ||
                                      states.contains(MaterialState.pressed)) {
                                    return Colors.transparent;
                                  }
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
                            onPressed: () {}),
                      )),
                  onEditingComplete: () async {
                    context.read<ChatBloc>().add(SendMessage(
                        content: _chatInputController.text, to: widget.userId.item1, toUser: widget.userId.item2));
                    _chatInputController.text = '';
                  },
                ),
              ],
            ));
      }),
    );
  }
}
