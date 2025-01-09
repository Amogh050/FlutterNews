import 'package:flutter/material.dart';
import 'package:newsapp/model/news_model.dart';
import 'package:url_launcher/url_launcher.dart';  // For launching the full article URL

class NewsDetailPage extends StatelessWidget {
  final NewsModel news;

  const NewsDetailPage({required this.news, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title ?? 'Article Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image if available
            if (news.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  news.urlToImage!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            // Headline (title)
            Text(
              news.title ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Date published
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  news.publishedAt ?? 'No Date',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Displaying the description or the first paragraph
            Text(
              news.description ?? 'No Description Available',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 15),

            // Content paragraph(s)
            Text(
              (news.content != null && news.content!.length > 200)
                  ? '${news.content!.substring(0, 200)}...'  // Display part of content
                  : news.content ?? 'No Content Available',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Button to read full article
            ElevatedButton(
              onPressed: () async {
                if (news.url != null) {
                  Uri articleUri = Uri.parse(news.url!);
                  if (await canLaunchUrl(articleUri)) {
                    await launchUrl(articleUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open the article.')),
                    );
                  }
                }
              },
              child: const Text("Read Full Article"),
            ),
          ],
        ),
      ),
    );
  }
}
