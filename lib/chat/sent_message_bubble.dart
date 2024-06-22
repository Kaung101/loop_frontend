import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/components/colors.dart';
import 'package:loop/util/env.dart';

class SentMessageBubble extends StatelessWidget {
  final String message;
  final MessageType type;
  final String media;

  const SentMessageBubble({
    super.key,
    required this.message,
    required this.type,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: type == MessageType.text
                  ? Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    )
                  : media.isNotEmpty
                      ? Image.network(
                          '${AppEnv.getBaseUrl()}/media?media_id=$media',
                          width: 150)
                      : Image.memory(base64Decode(message), width: 150)),
        ),
        // CustomPaint(painter: Triangle(Colors.grey[900])),
      ],
    ));

    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }
}
