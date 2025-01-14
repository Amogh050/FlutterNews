import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/provider/news_provider.dart';
import 'package:newsapp/service/location_service.dart';
import 'package:newsapp/service/search_delegate.dart';
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
  String searchQuery = ''; // To store the search query

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    String? location = await LocationService().getUserLocation();
    ref.read(newsProvider.notifier).fetchNews(
        location ?? 'us', selectedCategory, searchQuery); // Pass searchQuery
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    _fetchNews(); // Re-fetch news when category is selected
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    _fetchNews(); // Fetch news when a search query is entered
  }

  @override
  Widget build(BuildContext context) {
    final newsList = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch(
                context: context,
                delegate: NewsSearchDelegate(
                  onSearch: _onSearch, // Pass the search query to the HomePage
                ),
              );
              if (query != null && query.isNotEmpty) {
                _onSearch(query); // Trigger the search if there's a valid query
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNews, // Refresh on pull-down
        child: newsList.isEmpty
            ? Center(
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.blue,
                ),
              ) // Show loader during fetch
            : Column(
                children: [
                  // Categories list at the top
                  CategoryListWidget(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),

                  // Display top news card
                  Expanded(
                    child: ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Top news is the first news article
                          return TopNewsCard(news: newsList[0]);
                        } else {
                          // Rest of the news articles
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
