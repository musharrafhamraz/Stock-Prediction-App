import 'package:flutter/material.dart';
import 'api_service.dart';
import 'textbook.dart'; // This file contains the textbook content

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  // Function to find relevant content
  String findRelevantText(String query) {
    for (var page in textbookContent) {
      if (page.toLowerCase().contains(query.toLowerCase())) {
        return page; // Return the first matching content
      }
    }
    return ""; // No match found
  }

  void sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"text": userMessage, "isUser": true});
    });

    _controller.clear();

    // Step 1: Try to find relevant content in the book
    String textbookResponse = findRelevantText(userMessage);

    if (textbookResponse.isNotEmpty) {
      // Step 2: Summarize the content while maintaining textbook language level
      String summarizedText = await GroqService.summarizeText(textbookResponse);

      setState(() {
        messages.add({"text": summarizedText, "isUser": false});
      });
    } else {
      // Step 3: If no match is found, ask Groq API to answer
      String botResponse = await GroqService.sendMessage(userMessage);

      setState(() {
        messages.add({"text": botResponse, "isUser": false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chemistry Textbook Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: messages[index]["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: messages[index]["isUser"]
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[index]["text"],
                      style: TextStyle(
                          color: messages[index]["isUser"]
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
