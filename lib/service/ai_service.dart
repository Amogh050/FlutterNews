import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchOpenAIResponse(String userMessage, String apiKey) async {
  if (apiKey.isEmpty) {
    throw Exception('API key is missing. Please provide a valid API key.');
  }

  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  try {
    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-4o', // Correct OpenAI model
            'messages': [
              {'role': 'system', 'content': 'You are a helpful assistant.'},
              {'role': 'user', 'content': userMessage},
            ],
          }),
        )
        .timeout(const Duration(seconds: 15)); // Add a timeout

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Safely access the response content
      if (data['choices'] != null &&
          data['choices'].isNotEmpty &&
          data['choices'][0]['message'] != null &&
          data['choices'][0]['message']['content'] != null) {
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Unexpected response format from OpenAI API.');
      }
    } else {
      throw Exception(
          'Failed to fetch response: ${response.statusCode}, ${response.body}');
    }
  } on http.ClientException catch (e) {
    throw Exception('HTTP Client Error: $e');
  } on TimeoutException {
    throw Exception('Request to OpenAI API timed out.');
  } catch (e) {
    throw Exception('An unexpected error occurred: $e');
  }
}

Future<String> fetchGeminiResponse(String userMessage, String apiKey) async {
  if (apiKey.isEmpty) {
    throw Exception('API key is missing. Please provide a valid API key.');
  }

  // Correct Gemini API endpoint
  final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash-002:generateContent?key=$apiKey');

  try {
    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'contents': [
              {'role': 'user', 'parts': [{'text': userMessage}]}
            ],
          }),
        )
        .timeout(const Duration(seconds: 15)); // Add a timeout

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Safely access the response content
      if (data['candidates'] != null &&
          data['candidates'].isNotEmpty &&
          data['candidates'][0]['content'] != null &&
          data['candidates'][0]['content']['parts'] != null &&
          data['candidates'][0]['content']['parts'].isNotEmpty &&
          data['candidates'][0]['content']['parts'][0]['text'] != null) {
        return data['candidates'][0]['content']['parts'][0]['text'].trim();
      } else {
        throw Exception('Unexpected response format from Gemini API.');
      }
    } else {
      throw Exception(
          'Failed to fetch response: ${response.statusCode}, ${response.body}');
    }
  } on http.ClientException catch (e) {
    throw Exception('HTTP Client Error: $e');
  } on TimeoutException {
    throw Exception('Request to Gemini API timed out.');
  } catch (e) {
    throw Exception('An unexpected error occurred: $e');
  }
}
