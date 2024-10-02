import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../db/DBHelper.dart';
import '../models/article.dart';


class NewsService {
  static const String baseUrl = "https://newsapi.org/v2";
  static const String apiKey = "a7ebed0b55b041e7a20fc6ef542c5322";

  Future<List<Article>> fetchNews() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // Fetch from local database if offline
      return await DBHelper().getArticles();
    } else {
      final response = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> articlesJson = jsonData['articles'];
        List<Article> articles = articlesJson.map((json) => Article.fromJson(json)).toList();

        // Clear old data and insert new data into the local database
        await DBHelper().clearArticles();
        for (var article in articles) {
          await DBHelper().insertArticle(article);
        }

        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    }
  }
}
