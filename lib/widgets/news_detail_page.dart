import 'package:flutter/material.dart';
import 'package:newsapp/model/news_model.dart';
import 'package:newsapp/service/ai_service.dart';
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
    const apiKey = 'your-openai-api-key'; // Replace with your OpenAI API key

    if (widget.news.url == null) {
      setState(() {
        summary = 'No URL available for summarization.';
        isLoading = false;
      });
      return;
    }

    try {
      final prompt = 'Summarize the following news article in a few sentences: ${widget.news.url}';
      final generatedSummary = await fetchOpenAIResponse(prompt, apiKey);
      setState(() {
        summary = generatedSummary;
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
        title: Text(widget.news.title ?? 'Article Details'),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Date published
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  widget.news.publishedAt ?? 'No Date',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Displaying the description or the first paragraph
            Text(
              widget.news.description ?? 'No Description Available',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 15),

            // AI-generated summary
            isLoading
                ? const Center(child: CircularProgressIndicator())
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
