import 'package:flutter/material.dart';
import 'package:newsapp/model/news_model.dart';
import 'package:newsapp/service/ai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel news;

  const NewsDetailPage({required this.news, super.key});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  String? summary; // To store the AI-generated summary
  bool isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  /// Fetch summary using the API service
  Future<void> fetchSummary() async {
    // Retrieve the API key from the .env file
    final apiKey = dotenv.env['OPENAI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        summary = 'API key is missing or not set in the .env file.';
        isLoading = false;
      });
      return;
    }

    if (widget.news.url == null) {
      setState(() {
        summary = 'No URL available for summarization.';
        isLoading = false;
      });
      return;
    }

    try {
      final prompt =
          'Summarize the following news article in a few sentences: ${widget.news.url} and use this content: ${widget.news.content}';
      final generatedSummary = await fetchOpenAIResponse(prompt, apiKey);
      setState(() {
        if (summary == "NA") {
          summary = "There was an error generating the summary.";
        } else {
          summary = generatedSummary;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        summary = 'An error occurred while fetching the summary.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Article Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.save,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image if available
            if (widget.news.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.news.urlToImage!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            // Headline (title)
            Text(
              widget.news.title ?? 'No Title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Date published
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  widget.news.publishedAt ?? DateTime.now().toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // AI-generated summary
            isLoading
                ? const Center(
                    child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text("Fetching the summary using AI..."),
                    ],
                  ))
                : Text(
                    summary ?? 'No summary available.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
            const SizedBox(height: 20),

            // Button to read full article
            ElevatedButton(
              onPressed: () async {
                if (widget.news.url != null) {
                  Uri articleUri = Uri.parse(widget.news.url!);
                  if (await canLaunchUrl(articleUri)) {
                    await launchUrl(articleUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Could not open the article.')),
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
