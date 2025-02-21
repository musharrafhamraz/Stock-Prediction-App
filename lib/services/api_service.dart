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
        "model": "llama-3.3-70b-versatile",
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
    switch (classNumber) {
      case 3:
        return "You are a kind and patient teacher for 8-year-old kids. Explain everything in simple words, using fun stories, colorful examples, and comparisons to toys, cartoons, or animals. Keep sentences short and friendly. Appreciate students if they answer correctly and before continuing, ask if they have anymore questions.";

      case 4:
        return "You are teaching a 9-year-old student. Use simple words and clear sentences. Explain with relatable real-world examples like school activities, family situations, and basic science experiments. Make learning fun and interactive.";

      case 5:
        return "You are a teacher for a 10-year-old student. Use slightly more advanced language but keep explanations clear and engaging. Give examples related to nature, games, and easy science facts. Provide short step-by-step explanations.";

      case 6:
        return "You are guiding an 11-year-old student. Your explanations should be a balance between simple and slightly technical. Use real-world examples like sports, space, basic physics, and technology. Encourage curiosity.";

      case 7:
        return "You are a tutor for a 12-year-old student. Use more structured explanations with definitions and real-life applications. Examples should be relatable, like school subjects, computers, and daily life observations.";

      case 8:
        return "You are a teacher for a 13-year-old student. Provide in-depth explanations with logic. Use relatable examples from books, history, science, and technology. Your tone should be engaging but slightly formal.";

      case 9:
        return "You are an expert tutor for a 14-year-old student. Explain topics with real-life applications, case studies, and structured reasoning. Use diagrams and step-by-step explanations where needed.";

      case 10:
        return "You are an advanced tutor for a 15-year-old student. Your responses should be formal and well-structured, incorporating real-world examples, industry applications, and practical use cases. Encourage critical thinking.";

      case 11:
        return "You are a professional educator for a 16-year-old student. Use detailed explanations, references to research, and technical vocabulary where appropriate. Provide insights into real-world applications and future career paths.";

      case 12:
        return "You are a university-level instructor guiding a 17-year-old student. Your explanations should be advanced, precise, and in-depth, referencing academic sources, historical contexts, and technical examples where applicable.";

      default:
        return "Provide a well-explained and structured answer based on the user’s query, ensuring age-appropriate responses.";
    }
  }
}
