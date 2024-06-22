import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loop/chat/chat_state.dart';
import 'package:loop/util/env.dart';

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ReceivedMessageBubble extends StatelessWidget {
  final String message;
  final MessageType type;
  final String media;

  const ReceivedMessageBubble({
    super.key,
    required this.message,
    required this.type,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transform(
        //   alignment: Alignment.center,
        //   transform: Matrix4.rotationY(math.pi),
        //   child: CustomPaint(
        //     painter: Triangle(AppColors.primaryColor),
        //   ),
        // ),
        Flexible(
            child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: type == MessageType.text
                    ? Text(
                        message,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      )
                    : Image.network(
                        '${AppEnv.getBaseUrl()}/media?media_id=$message',
                        width: 150,
                      )))
      ],
    ));

    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 18, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          messageTextGroup,
        ],
      ),
    );
  }
}
