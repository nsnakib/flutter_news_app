import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../models/article.dart';
import '../widgets/article_list_tile.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> news;
  List<Article> allArticles = []; // Stores all articles
  List<Article> filteredArticles = []; // Stores filtered articles
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    news = NewsService().fetchNews();
    _loadArticles(); // Fetch articles
  }

  Future<void> _loadArticles() async {
    final fetchedArticles = await NewsService().fetchNews();
    setState(() {
      allArticles = fetchedArticles;
      filteredArticles = fetchedArticles; // Start with all articles shown
    });
  }

  Future<void> _refreshNews() async {
    setState(() {
      news = NewsService().fetchNews();
    });
    await _loadArticles(); // Reload articles after refresh
  }

  void _filterArticles(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredArticles = allArticles.where((article) {
        return article.title.toLowerCase().contains(searchQuery) ||
            article.description.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _filterArticles, // Call filter logic as the user types
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: FutureBuilder<List<Article>>(
          future: news,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No news available'));
            } else {
              return ListView.builder(
                itemCount: filteredArticles.length, // Show filtered articles
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: ArticleListTile(article: article),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
