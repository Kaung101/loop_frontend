import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop/chat/chat_bloc.dart';
import 'package:loop/chat/chat_event.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/chat/received_message_bubble.dart';
import 'package:loop/chat/sent_message_bubble.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/components/colors.dart';
import 'package:mime/mime.dart';
import 'package:tuple/tuple.dart';

class DirectMessageView extends StatefulWidget {
  const DirectMessageView({super.key, required this.userId});

  final Tuple2<String, String> userId;

  @override
  State<DirectMessageView> createState() => _DirectMessageViewState();
}

class _DirectMessageViewState extends State<DirectMessageView> {
  final TextEditingController _chatInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Uint8List? _pickedFile;
  XFile? picked;
  final OverlayPortalController _overlayController = OverlayPortalController();

  final _buttonStyle = ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
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
  );

  List<Widget> _buildHistory(ChatState state) {
    if (state.chatHistory[widget.userId] == null) {
      return List.from([]);
    }

    return List.from(state.chatHistory[widget.userId]!.map((message) {
      if (message.from == widget.userId.item1) {
        return ReceivedMessageBubble(
            message: message.type == MessageType.text
                ? message.content
                : message.media!,
            type: message.type,
            media: message.media!);
      } else {
        return SentMessageBubble(
            message: message.content,
            type: message.type,
            media: message.media!);
      }
    }));
  }

  List<Widget> _buildMessage(ChatState state) {
    if (state.messages[widget.userId] == null) {
      return List.from([]);
    }

    return List.from(
        state.messages[widget.userId]!.map((message) {
      if (message.from == widget.userId.item1) {
        return ReceivedMessageBubble(
            message: message.content,
            type: message.type,
            media: message.media ?? '');
      } else {
        return SentMessageBubble(
            message: message.content,
            type: message.type,
            media: message.media ?? '');
      }
    }));
  }

  @override
  void initState() {
    super.initState();

    context.read<ChatBloc>().add(FetchChatHistory(
        userId: widget.userId.item1, userName: widget.userId.item2));
    context.read<ChatBloc>().add(ClearBuffer(userId: widget.userId.item1, userName: widget.userId.item2));
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
                Expanded(
                    child: ListView(
                        controller: _scrollController,
                        reverse: true,
                        children: [
                      ..._buildMessage(state).reversed,
                      ..._buildHistory(state).reversed,
                    ])),
                Row(children: [
                  Expanded(
                      child: TextField(
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
                              style: _buttonStyle,
                              onPressed: () async {
                                final ImagePicker imagePicker = ImagePicker();
                                final pickedFile = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  _pickedFile = await pickedFile.readAsBytes();
                                  picked = pickedFile;
                                  _overlayController.show();
                                }
                              }),
                        )),
                    onEditingComplete: () async {
                      context.read<ChatBloc>().add(SendMessage(
                          content: _chatInputController.text,
                          to: widget.userId.item1,
                          toUser: widget.userId.item2));
                      _chatInputController.text = '';
                      _scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                  )),
                  IconButton(
                    color: AppColors.primaryColor,
                    icon: const Icon(Icons.send),
                    style: _buttonStyle,
                    onPressed: () {
                      if (_pickedFile != null) {
                        final file = base64Encode(_pickedFile!);
                        final String? mime = lookupMimeType(picked!.path);
                        context.read<ChatBloc>().add(SendMediaMessage(
                              content: file,
                              to: widget.userId.item1,
                              toUser: widget.userId.item2,
                              mimetype: mime!,
                            ));
                        _overlayController.hide();
                        _pickedFile = null;
                      } else if (_chatInputController.text.isNotEmpty) {
                        context.read<ChatBloc>().add(SendMessage(
                            content: _chatInputController.text,
                            to: widget.userId.item1,
                            toUser: widget.userId.item2));
                        _chatInputController.text = '';
                      }
                    },
                  ),
                ]),
                OverlayPortal(
                    controller: _overlayController,
                    overlayChildBuilder: (BuildContext build) {
                      return Positioned(
                          right: 20,
                          bottom: 100,
                          child: _pickedFile != null
                              ? Stack(children: [
                                  Image.memory(width: 125, _pickedFile!),
                                  Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              _overlayController.hide();
                                              _pickedFile = null;
                                            },
                                            child: const CircleAvatar(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                                radius: 10,
                                                child: Icon(
                                                  Icons.close,
                                                  size: 15,
                                                  color:
                                                      AppColors.backgroundColor,
                                                )),
                                          ))),
                                ])
                              : Container());
                    }),
              ],
            ));
      }),
    );
  }
}
