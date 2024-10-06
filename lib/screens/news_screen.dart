import 'package:flutter/material.dart';
import '../BookmarkedArticlesScreen.dart';
import '../services/news_service.dart';
import '../models/article.dart';
import '../widgets/article_list_tile.dart';


class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> news;
  List<Article> allArticles = [];
  List<Article> filteredArticles = [];
  String searchQuery = "";
  List<Article> bookmarkedArticles = [];

  @override
  void initState() {
    super.initState();
    news = NewsService().fetchNews();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    final fetchedArticles = await NewsService().fetchNews();
    setState(() {
      allArticles = fetchedArticles;
      filteredArticles = fetchedArticles;
    });
  }

  Future<void> _refreshNews() async {
    setState(() {
      news = NewsService().fetchNews();
    });
    await _loadArticles();
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

  void _toggleBookmark(Article article) {
    setState(() {
      if (bookmarkedArticles.contains(article)) {
        bookmarkedArticles.remove(article);
      } else {
        bookmarkedArticles.add(article);
      }
    });
  }

  void _viewBookmarks() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookmarkedArticlesScreen(
          bookmarkedArticles: bookmarkedArticles,
          onBookmarkToggle: _toggleBookmark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _filterArticles,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: _viewBookmarks, // Opens bookmarked articles screen
          ),
        ],
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
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: ArticleListTile(
                      article: article,
                      isBookmarked: bookmarkedArticles.contains(article),
                      onBookmarkToggle: _toggleBookmark,
                    ),
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
