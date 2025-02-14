import 'package:chatbot/services/api_service.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final int classNumber;

  ChatScreen({required this.classNumber});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  final GroqService _groqService = GroqService();

  void sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": _controller.text});
    });

    String response =
        await _groqService.getResponse(widget.classNumber, _controller.text);

    setState(() {
      messages.add({"sender": "bot", "text": response});
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Class ${widget.classNumber} Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  text: messages[index]["text"]!,
                  isUser: messages[index]["sender"] == "user",
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
