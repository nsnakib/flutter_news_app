import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/NewsController.dart';
import '../widgets/article_list_tile.dart';

class BookmarkedArticlesScreen extends StatelessWidget {
  final NewsController newsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Articles'),
      ),
      body: Obx(() {
        if (newsController.bookmarkedArticles.isEmpty) {
          return Center(
            child: Text(
              'No bookmarked articles',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return ListView.builder(
          itemCount: newsController.bookmarkedArticles.length,
          itemBuilder: (context, index) {
            final article = newsController.bookmarkedArticles[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: ArticleListTile(
                article: article,
                onBookmarkToggle: newsController.toggleBookmark,
                onTap: () {
                  Get.toNamed('/bookmarked/articleDetails', arguments: article);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
