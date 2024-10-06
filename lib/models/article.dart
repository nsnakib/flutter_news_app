import 'package:get/get.dart';

class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  RxBool isBookmarked; // Use RxBool for reactive state

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    bool isBookmarked = false, // Default to false
  }) : isBookmarked = isBookmarked.obs; // Initialize as reactive

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
      'isBookmarked': isBookmarked.value ? 1 : 0, // Convert boolean to integer
    };
  }
}
