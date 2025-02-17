// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import '../services/api_service.dart';
// import '../widgets/chat_bubble.dart';

// class ChatScreen extends StatefulWidget {
//   final int classNumber;

//   const ChatScreen({super.key, required this.classNumber});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final GroqService _groqService = GroqService();
//   List<Map<String, String>> messages = [];
//   bool isLoading = false; // For showing typing animation

//   void sendMessage() async {
//     String userMessage = _controller.text.trim();
//     if (userMessage.isEmpty) return;

//     setState(() {
//       messages.add({"sender": "user", "text": userMessage});
//       isLoading = true; // Show typing animation
//     });

//     _controller.clear();

//     // Fetch response from LLM (Groq API)
//     String rawResponse =
//         await _groqService.getResponse(widget.classNumber, userMessage);

//     // ✅ Extract actual answer by removing <think>...</think> parts
//     String filteredResponse = _extractActualAnswer(rawResponse);

//     setState(() {
//       messages.add({"sender": "bot", "text": filteredResponse});
//       isLoading = false; // Hide typing animation
//     });
//   }

//   /// **📌 Function to remove <think>...</think> part from response**
//   String _extractActualAnswer(String response) {
//     RegExp regex = RegExp(r"<think>.*?</think>", dotAll: true);
//     return response.replaceAll(regex, "").trim();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[50], // Light school-themed background
//       appBar: AppBar(
//         title: Text(
//           "Class ${widget.classNumber}",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         children: [
//           /// 🗨️ Chat Area
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: messages.length + (isLoading ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == messages.length && isLoading) {
//                   return _buildTypingIndicator(); // Show animation
//                 }
//                 return ChatBubble(
//                   text: messages[index]["text"]!,
//                   isUser: messages[index]["sender"] == "user",
//                 );
//               },
//             ),
//           ),

//           /// 📩 Input Field
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Ask me anything...",
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 14, horizontal: 20),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: sendMessage,
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.blueAccent,
//                     radius: 24,
//                     child: Icon(Icons.send, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 🎥 **Typing Animation (Lottie)**
//   Widget _buildTypingIndicator() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Lottie.asset(
//           'lib/assets/robot_typing.json', // Make sure you have this Lottie JSON
//           width: 150,
//           height: 100,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import '../services/api_service.dart';
import '../services/chat_storage.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final int classNumber;
  final String? chatId; // If null, it's a new chat

  const ChatScreen({super.key, required this.classNumber, this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GroqService _groqService = GroqService();
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  String currentChatId = "";

  @override
  void initState() {
    super.initState();
    currentChatId = widget.chatId ?? _generateChatId();
    _loadChatHistory();
  }

  /// **📥 Load chat history**
  void _loadChatHistory() async {
    List<Map<String, String>> savedMessages =
        await ChatStorageService.getChat(currentChatId);
    setState(() {
      messages = savedMessages;
    });
  }

  /// **📤 Send message & get response**
  void sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": userMessage});
      isLoading = true;
    });

    _controller.clear();

    String rawResponse =
        await _groqService.getResponse(widget.classNumber, userMessage);

    String filteredResponse = _extractActualAnswer(rawResponse);

    setState(() {
      messages.add({"sender": "bot", "text": filteredResponse});
      isLoading = false;
    });

    // **Save conversation**
    ChatStorageService.saveChat(currentChatId, messages);
  }

  /// **📝 Extract actual response (removes <think>...</think>)**
  String _extractActualAnswer(String response) {
    RegExp regex = RegExp(r"<think>.*?</think>", dotAll: true);
    return response.replaceAll(regex, "").trim();
  }

  /// **🎲 Generate a random chat ID**
  String _generateChatId() {
    return "chat_${Random().nextInt(999999)}";
  }

  /// **🗑️ Delete chat**
  void _deleteChat(String chatId) async {
    await ChatStorageService.deleteChat(chatId);
    setState(() {});
  }

  /// **🚀 Start a new chat**
  void _startNewChat() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(classNumber: widget.classNumber),
      ),
    );
  }

  /// **📜 Build Chat History List in Drawer**
  Widget _buildChatHistory() {
    return FutureBuilder<Map<String, dynamic>>(
      future: ChatStorageService.getAllChats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No chat history"));
        }

        return ListView(
          children: snapshot.data!.keys.map((chatId) {
            return ListTile(
              title: Text("Chat: ${messages[0]["text"]}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteChat(chatId);
                },
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        classNumber: widget.classNumber, chatId: chatId),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          "Class ${widget.classNumber}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: const Center(
                child: Text(
                  "Chat History",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Expanded(child: _buildChatHistory()),

            /// **➕ New Chat Button**
            ListTile(
              leading: const Icon(Icons.add, color: Colors.blueAccent),
              title: const Text("New Chat"),
              onTap: _startNewChat,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          /// **🗨️ Chat Messages**
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isLoading) {
                  return _buildTypingIndicator();
                }
                return ChatBubble(
                  text: messages[index]["text"]!,
                  isUser: messages[index]["sender"] == "user",
                );
              },
            ),
          ),

          /// **📩 Input Field**
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

  /// **🎥 Typing Animation**
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Lottie.asset(
          'lib/assets/robot_typing.json',
          width: 150,
          height: 100,
        ),
      ),
    );
  }
}
