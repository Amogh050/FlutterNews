import 'package:flutter/material.dart';
import 'package:flutter_news/model/news_model.dart';
import 'package:flutter_news/pages/news_detail_page.dart';

class TopNewsCard extends StatelessWidget {
  final NewsModel news;

  const TopNewsCard({
    required this.news,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsDetailPage(news: news)),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            news.urlToImage != null
                ? Image.network(
                    news.urlToImage ?? '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Placeholder(),
                  )
                : const Text("No image available"),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                news.title ?? 'No Title', // Added null check for title
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
