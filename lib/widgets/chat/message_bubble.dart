import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.key,
      required this.message,
      required this.userImageurl,
      required this.isMe,
      required this.username});

  final Key key;
  final String message;
  final bool isMe;
  final String username;
  final String userImageurl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12)),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: isMe? null:120,
          right: isMe? 120:null,
          top: 0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              userImageurl,
            ),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
