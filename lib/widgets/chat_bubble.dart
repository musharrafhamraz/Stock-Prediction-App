import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  final String userImage = "lib/assets/male_std.jpg";
  final String botImage = "lib/assets/robot.jpg";

  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(botImage),
          ),
          const SizedBox(width: 4),
        ],

        /// **💬 Message Bubble**
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
                bottomRight: isUser ? Radius.zero : const Radius.circular(12),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),

        if (isUser) ...[
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(userImage),
          ),
        ],
      ],
    );
  }
}
