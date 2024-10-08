import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Article article = Get.arguments; // Get the passed article

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (article.urlToImage.isNotEmpty)
              Image.network(article.urlToImage)
            else
              Icon(Icons.image_not_supported),
            SizedBox(height: 10),
            Text(article.description),
          ],
        ),
      ),
    );
  }
}
