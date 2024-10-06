class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  bool isBookmarked; // New field to track if an article is bookmarked

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    this.isBookmarked = false, // Default to false
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'] ?? 'No description available',
      url: json['url'],
      urlToImage: json['urlToImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'isBookmarked': isBookmarked ? 1 : 0, // Convert boolean to integer
    };
  }
}
