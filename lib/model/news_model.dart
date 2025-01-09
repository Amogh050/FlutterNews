class NewsModel {
  final String? title;
  final String? description;
  final String? content;
  final String? publishedAt;
  final String? urlToImage;
  final String? url;  // Add URL field

  NewsModel({
    this.title,
    this.description,
    this.content,
    this.publishedAt,
    this.urlToImage,
    this.url,  // Initialize URL
  });

  // Factory method to create an instance of NewsModel from JSON
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      publishedAt: json['publishedAt'] as String?,
      urlToImage: json['urlToImage'] as String?,
      url: json['url'] as String?,  // Map URL field
    );
  }

  // Convert NewsModel instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'publishedAt': publishedAt,
      'urlToImage': urlToImage,
      'url': url,  // Add URL to toJson
    };
  }
}
