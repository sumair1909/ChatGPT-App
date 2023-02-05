import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        sender == "user"
            ? CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 19,
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/user_image.png")),
              )
            : CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Image.asset("assets/chatbot_image.png"),
              ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            text.trim(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
