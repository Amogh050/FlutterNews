import 'package:flutter/material.dart';

class NewsSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;

  NewsSearchDelegate({required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';  // Clear the query
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);  // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Instead of calling onSearch() here, close the search and handle it afterward
    close(context, query);  // Pass the query back and close the search
    return const SizedBox.shrink();  // No UI required here
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('Enter search term to find news articles.'),
    );
  }
}
