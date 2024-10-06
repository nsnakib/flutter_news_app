import 'package:flutter/material.dart';
import '../models/article.dart';
import '../widgets/article_list_tile.dart';

class BookmarkedArticlesScreen extends StatelessWidget {
  final List<Article> bookmarkedArticles;
  final Function(Article) onBookmarkToggle;

  const BookmarkedArticlesScreen({
    Key? key,
    required this.bookmarkedArticles,
    required this.onBookmarkToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Articles'),
      ),
      body: bookmarkedArticles.isEmpty
          ? Center(
        child: Text(
          'No bookmarked articles',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: bookmarkedArticles.length,
        itemBuilder: (context, index) {
          final article = bookmarkedArticles[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: ArticleListTile(
              article: article,
              onBookmarkToggle: onBookmarkToggle,
              isBookmarked: true, // Bookmarked articles are always bookmarked
            ),
          );
        },
      ),
    );
  }
}
