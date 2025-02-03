import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  static const String apiKey =
      "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"; // Replace with actual key
  static const String apiUrl =
      "https://api.groq.com/openai/v1/chat/completions";

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {"role": "user", "content": message}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "Error: ${response.statusCode}, ${response.body}";
      }
    } catch (e) {
      return "Failed to get response from Groq API: $e";
    }
  }

  static Future<String> summarizeText(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "user",
              "content":
                  "Summarize the following text while maintaining its language style: $text"
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "Error summarizing: ${response.statusCode}, ${response.body}";
      }
    } catch (e) {
      return "Failed to summarize text: $e";
    }
  }
}
