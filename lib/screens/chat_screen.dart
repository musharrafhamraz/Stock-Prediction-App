import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/api_service.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final int classNumber;

  const ChatScreen({super.key, required this.classNumber});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GroqService _groqService = GroqService();
  List<Map<String, String>> messages = [];
  bool isLoading = false; // For showing typing animation

  void sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": userMessage});
      isLoading = true; // Show typing animation
    });

    _controller.clear();

    // Fetch response from LLM (Groq API)
    String rawResponse =
        await _groqService.getResponse(widget.classNumber, userMessage);

    // ✅ Extract actual answer by removing <think>...</think> parts
    String filteredResponse = _extractActualAnswer(rawResponse);

    setState(() {
      messages.add({"sender": "bot", "text": filteredResponse});
      isLoading = false; // Hide typing animation
    });
  }

  /// **📌 Function to remove <think>...</think> part from response**
  String _extractActualAnswer(String response) {
    RegExp regex = RegExp(r"<think>.*?</think>", dotAll: true);
    return response.replaceAll(regex, "").trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light school-themed background
      appBar: AppBar(
        title: Text(
          "Class ${widget.classNumber}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          /// 🗨️ Chat Area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return _buildTypingIndicator(); // Show animation
                }
                return ChatBubble(
                  text: messages[index]["text"]!,
                  isUser: messages[index]["sender"] == "user",
                );
              },
            ),
          ),

          /// 📩 Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: sendMessage,
                  child: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 24,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🎥 **Typing Animation (Lottie)**
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Lottie.asset(
          'lib/assets/robot_typing.json', // Make sure you have this Lottie JSON
          width: 150,
          height: 100,
        ),
      ),
    );
  }
}
