import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For kDebugMode

import '../models/adventure.dart';
import '../models/message.dart'; // Needed to format history
import 'ai_service.dart';

class GroqAIService implements AIService {
  final String _apiUrl = "https://api.groq.com/openai/v1/chat/completions";
  final String _defaultModel = "qwen-qwq-32b"; // Default model as requested

  // --- IMPORTANT: API Key Management ---
  // NEVER hardcode API keys directly in the source code.
  // Use environment variables, a configuration file not checked into Git,
  // or a secure secrets management solution.
  final String _apiKey = const String.fromEnvironment('GROQ_API_KEY', defaultValue: 'YOUR_GROQ_API_KEY_HERE');
  // For testing, you might temporarily replace 'YOUR_GROQ_API_KEY_HERE'
  // or properly set up environment variables for your build process.
  // Example using --dart-define for Flutter run:
  // flutter run --dart-define=GROQ_API_KEY=gsk_YourActualApiKey

  // Helper function to make the API call
  Future<String> _makeApiCall(List<Map<String, dynamic>> messages, String? modelOverride) async {
    if (_apiKey == 'YOUR_GROQ_API_KEY_HERE') {
       if (kDebugMode) {
         print("ERROR: GROQ_API_KEY is not set. Please configure it.");
       }
       throw Exception("GROQ API Key not configured.");
    }

    final selectedModel = modelOverride ?? _defaultModel;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    final body = jsonEncode({
      "messages": messages,
      "model": selectedModel,
      "temperature": 0.6,
      "max_tokens": 1024, // Adjusted from 14096 for potentially faster responses, tune as needed
      "top_p": 0.95,
      "stream": false, // As requested
      "stop": null,
    });

    try {
      if (kDebugMode) {
        print("--- Sending to Groq API ---");
        print("Model: $selectedModel");
        // print("Messages: ${jsonEncode(messages)}"); // Be careful logging full history
      }

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      if (kDebugMode) {
         print("--- Groq API Response ---");
         print("Status Code: ${response.statusCode}");
         // print("Body: ${response.body}"); // Log full body for debugging if necessary
      }

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // Ensure the response structure is as expected
        if (responseBody['choices'] != null &&
            responseBody['choices'].isNotEmpty &&
            responseBody['choices'][0]['message'] != null &&
            responseBody['choices'][0]['message']['content'] != null) {
          return responseBody['choices'][0]['message']['content'] as String;
        } else {
          throw Exception("Invalid response format from Groq API.");
        }
      } else {
        // Attempt to parse error message from Groq
        String errorMessage = "Groq API Error: ${response.statusCode}";
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody['error'] != null && errorBody['error']['message'] != null) {
            errorMessage += " - ${errorBody['error']['message']}";
          } else {
             errorMessage += " - ${response.body}"; // Fallback to raw body
          }
        } catch (_) {
           errorMessage += " - ${response.body}"; // Fallback if error parsing fails
        }
         throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error calling Groq API: $e");
      }
      // Rethrow a more specific exception or handle it
      throw Exception("Failed to communicate with AI service: $e");
    }
  }

  @override
  Future<String> generateResponse({
    required Adventure adventure,
    required String userInput,
    String? model,
  }) async {
    // Construct the message history in the format Groq expects
    List<Map<String, dynamic>> messages = adventure.conversationHistory.map((msg) {
      return {"role": msg.sender.toLowerCase() == 'ai' ? 'assistant' : 'user', "content": msg.content};
    }).toList();

    // Add the latest user input
    messages.add({"role": "user", "content": userInput});

    // TODO: Add system prompt if needed (e.g., defining the AI's role)
    // messages.insert(0, {"role": "system", "content": "You are a helpful RPG game master..."});

    return await _makeApiCall(messages, model);
  }

  @override
  Future<String> generateDiceRollResponse({
    required Adventure adventure,
    required int rollResult,
    String? model,
  }) async {
    // Construct the message history
     List<Map<String, dynamic>> messages = adventure.conversationHistory.map((msg) {
      return {"role": msg.sender.toLowerCase() == 'ai' ? 'assistant' : 'user', "content": msg.content};
    }).toList();

    // Add a specific prompt for the dice roll outcome
    // TODO: Refine this prompt based on game context/rules
    messages.add({
      "role": "user",
      "content": "I just rolled a D20 and got $rollResult. Based on the current situation (${adventure.gameState.currentScene}), describe what happens."
    });

     // TODO: Add system prompt if needed
    // messages.insert(0, {"role": "system", "content": "You are a helpful RPG game master..."});

    return await _makeApiCall(messages, model);
  }

   @override
  Future<String> generateInitialPrompt({
    required String scenarioId, // Or Adventure adventure
    String? model,
  }) async {
     // Construct a specific prompt to ask the AI for the starting message
     // TODO: Refine this prompt, potentially including scenario details if available
     List<Map<String, dynamic>> messages = [
       // {"role": "system", "content": "You are starting a new text-based RPG adventure."},
       {"role": "user", "content": "Generate the very first message to the player to start the character creation process for the scenario '$scenarioId'. Ask the first question (e.g., character name or class). Keep it engaging."}
     ];

     return await _makeApiCall(messages, model);
  }
}