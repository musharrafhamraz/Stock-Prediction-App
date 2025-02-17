import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStorageService {
  static const String _chatsKey = "chats";

  /// **📥 Save a chat**
  static Future<void> saveChat(
      String chatId, List<Map<String, String>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> allChats = await getAllChats();

    allChats[chatId] =
        messages.map((msg) => Map<String, String>.from(msg)).toList();

    await prefs.setString(_chatsKey, jsonEncode(allChats));
  }

  /// **📤 Retrieve all chats**
  static Future<Map<String, dynamic>> getAllChats() async {
    final prefs = await SharedPreferences.getInstance();
    String? chatsJson = prefs.getString(_chatsKey);
    return chatsJson != null ? jsonDecode(chatsJson) : {};
  }

  /// **📜 Retrieve a specific chat**
  static Future<List<Map<String, String>>> getChat(String chatId) async {
    Map<String, dynamic> allChats = await getAllChats();
    if (allChats.containsKey(chatId)) {
      try {
        return List<Map<String, String>>.from(
          (allChats[chatId] as List)
              .map((msg) => Map<String, String>.from(msg)),
        );
      } catch (e) {
        print("Error retrieving chat: $e");
        return [];
      }
    }
    return [];
  }

  /// **🗑️ Delete a chat**
  static Future<void> deleteChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> allChats = await getAllChats();
    allChats.remove(chatId);
    await prefs.setString(_chatsKey, jsonEncode(allChats));
  }
}
