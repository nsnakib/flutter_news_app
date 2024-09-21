import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const String baseUrl = "https://newsapi.org/v2";
  static const String apiKey = "a7ebed0b55b041e7a20fc6ef542c5322"; // Replace with your actual API key

  Future<List<Article>> fetchNews() async {
    final response = await http.get(
      Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> articlesJson = jsonData['articles'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
