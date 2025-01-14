import 'package:http/http.dart' as http;
import 'package:newsapp/model/news_model.dart';
import 'dart:convert';

class NewsService {
  Future<List<NewsModel>> fetchNews({
    String? location,
    String? category,
    String? query,  // Add query parameter
  }) async {
    // Default location to 'us' if no location is provided
    final defaultLocation = location ?? 'us';
    print("defalult location: ");
    print(defaultLocation);
    
    // If a query is provided, use the query-based API endpoint, otherwise fallback to the top headlines
    final url = query != null && query.isNotEmpty
        ? 'https://newsapi.org/v2/everything?q=$query&apiKey=624ded5cb027418f95b90697ce027958'
        : category != null
            ? 'https://newsapi.org/v2/top-headlines?country=$defaultLocation&category=$category&apiKey=624ded5cb027418f95b90697ce027958'
            : 'https://newsapi.org/v2/top-headlines?country=$defaultLocation&apiKey=624ded5cb027418f95b90697ce027958';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List articles = data['articles'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
