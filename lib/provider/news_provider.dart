import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/model/news_model.dart';
import 'package:newsapp/service/news_service.dart';

class NewsNotifier extends StateNotifier<List<NewsModel>> {
  NewsNotifier() : super([]);

  Future<void> fetchNews(String location, [String? category, String? query]) async {
    try {
      final newsList = await NewsService().fetchNews(location: location, category: category, query: query);

      // Filter out articles with no content or description
      state = newsList.where((article) {
        return (article.title?.isNotEmpty ?? false) || (article.description?.isNotEmpty ?? false);
      }).toList();
    } catch (e) {
      state = []; // In case of an error
    }
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, List<NewsModel>>(
  (ref) => NewsNotifier(),
);
