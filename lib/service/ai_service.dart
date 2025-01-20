import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchOpenAIResponse(String userMessage, String apiKey) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {
          'role': 'user',
          'content': userMessage,
        },
      ],
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'].trim();
  } else {
    throw Exception('Failed to fetch response: ${response.statusCode}');
  }
}