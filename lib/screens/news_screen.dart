import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../BookmarkedArticlesScreen.dart';
import '../controllers/NewsController.dart';
import '../widgets/article_list_tile.dart';


class NewsScreen extends StatelessWidget {
  final NewsController newsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: newsController.filterArticles,
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
            onPressed: () => Get.to(() => BookmarkedArticlesScreen()), // Navigate using GetX
          ),
        ],
      ),
      body: Obx(() {
        if (newsController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (newsController.filteredArticles.isEmpty) {
          return Center(child: Text('No news available'));
        } else {
          return ListView.builder(
            itemCount: newsController.filteredArticles.length,
            itemBuilder: (context, index) {
              final article = newsController.filteredArticles[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ArticleListTile(
                  article: article,
                  onBookmarkToggle: newsController.toggleBookmark,
                ),
              );
            },
          );
        }
      }),
    );
  }
}
