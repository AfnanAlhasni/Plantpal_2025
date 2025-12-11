import 'dart:convert';
import 'package:flutter/services.dart';

class PlantChatBot {
  static List<dynamic> _data = [];

  /// Load your FAQ JSON from assets
  static Future<void> loadData() async {
    final raw = await rootBundle.loadString("assets/plant_faq.json");
    _data = json.decode(raw);
  }

  /// Get response based on user's question and language
  static String getResponse(String userQuestion, {String lang = "en"}) {
    userQuestion = userQuestion.toLowerCase();

    String bestAnswer = "";
    double bestScore = 0.0;

    for (var item in _data) {
      // Choose question in the correct language
      String faqQuestion = (lang == "ar")
          ? item["question_ar"].toLowerCase()
          : item["question_en"].toLowerCase();

      List<String> faqWords = faqQuestion.split(" ");
      int matchCount = 0;

      for (var word in faqWords) {
        if (userQuestion.contains(word)) matchCount++;
      }

      double score = matchCount / faqWords.length;

      if (score > bestScore) {
        bestScore = score;
        bestAnswer = (lang == "ar") ? item["answer_ar"] : item["answer_en"];
      }
    }

    // Default response if no good match
    if (bestScore < 0.3) {
      return (lang == "ar")
          ? "عذرًا، لا أعرف هذا بعد. حاول السؤال عن الري، الضوء، التربة أو العناية بالنبات."
          : "Sorry, I don't know this yet. Try asking about watering, sunlight, soil, or plant care.";
    }

    return bestAnswer;
  }
}
