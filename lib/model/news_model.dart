class NewsModel {
  final String? title;
  final String? description;
  final String? content;
  final String? publishedAt;
  final String? urlToImage;
  final String? url;

  NewsModel({
    this.title,
    this.description,
    this.content,
    this.publishedAt,
    this.urlToImage,
    this.url,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      publishedAt: json['publishedAt'] as String?,
      urlToImage: json['urlToImage'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'publishedAt': publishedAt,
      'urlToImage': urlToImage,
      'url': url,
    };
  }
}
