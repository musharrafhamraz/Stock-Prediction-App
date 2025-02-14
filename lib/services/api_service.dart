import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  final String apiKey =
      "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";
  final String baseUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<String> getResponse(int classNumber, String query) async {
    String prompt = generatePrompt(classNumber, query);

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "deepseek-r1-distill-llama-70b",
        "messages": [
          {"role": "system", "content": prompt},
          {"role": "user", "content": query},
        ],
      }),
    );

    var data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"];
  }

  String generatePrompt(int classNumber, String query) {
    if (classNumber == 3) {
      return "Respond like a friendly teacher using simple words and fun examples.";
    } else if (classNumber <= 6) {
      return "Use basic explanations and some real-world examples.";
    } else if (classNumber <= 9) {
      return "Give detailed explanations with real-life applications.";
    } else {
      return "Provide an advanced response with deep insights.";
    }
  }
}
