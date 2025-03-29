import 'package:flutter/material.dart';
import 'package:flutter_news/model/news_model.dart';
import 'package:flutter_news/service/ai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel news;

  const NewsDetailPage({required this.news, super.key});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  String? summary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        summary = 'API key is missing. Please configure it in the .env file.';
        isLoading = false;
      });
      return;
    }

    if (widget.news.url == null || widget.news.url!.isEmpty) {
      setState(() {
        summary = 'No URL available for summarization.';
        isLoading = false;
      });
      return;
    }

    if (widget.news.content == null || widget.news.content!.isEmpty) {
      setState(() {
        summary = 'No content available for summarization.';
        isLoading = false;
      });
      return;
    }

    try {
      final prompt = 'Summarize this article: ${widget.news.content} in 100 words.';
      final generatedSummary = await fetchGeminiResponse(prompt, apiKey);

      setState(() {
        summary = (generatedSummary != "NA" && generatedSummary.trim().isNotEmpty)
            ? generatedSummary
            : 'There was an error generating the summary.';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        summary = 'An error occurred while fetching the summary: $e';
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.news.urlToImage != null && widget.news.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.news.urlToImage!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),

            Text(
              widget.news.title ?? 'No Title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  widget.news.publishedAt != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.news.publishedAt!))
                      : 'Unknown Date',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            isLoading
                ? const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Fetching the summary using AI..."),
                      ],
                    ),
                  )
                : Text(
                    summary ?? 'No summary available.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final url = widget.news.url;

                if (url == null || url.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No valid URL available for this article.')),
                  );
                  return;
                }

                try {
                  final Uri articleUri = Uri.parse(url);

                  if (await canLaunchUrl(articleUri)) {
                    await launchUrl(articleUri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open the article.')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('An error occurred while opening the article.')),
                  );
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
