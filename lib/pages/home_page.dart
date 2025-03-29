import 'package:flutter/material.dart';
import 'package:flutter_news/provider/news_provider.dart';
import 'package:flutter_news/service/location_service.dart';
import 'package:flutter_news/service/search_delegate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/news_item_widget.dart';
import '../widgets/top_news_card.dart';
import '../widgets/category_list_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<String> categories = [
    'General',
    'Business',
    'Technology',
    'Sports',
    'Health',
    'Entertainment'
  ];
  String selectedCategory = 'General';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    String? location = await LocationService().getUserLocation();
    ref.read(newsProvider.notifier).fetchNews(
        location ?? 'us', selectedCategory, searchQuery);
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    _fetchNews();
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    final newsList = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FlutterNews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () async {
              final query = await showSearch(
                context: context,
                delegate: NewsSearchDelegate(
                  onSearch: _onSearch,
                ),
              );
              if (query != null && query.isNotEmpty) {
                _onSearch(query);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNews,
        child: newsList.isEmpty
            ? const Center(
                child: CircularProgressIndicator())
            : Column(
                children: [
                  CategoryListWidget(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return TopNewsCard(news: newsList[0]);
                        } else {
                          return NewsItemWidget(news: newsList[index]);
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
