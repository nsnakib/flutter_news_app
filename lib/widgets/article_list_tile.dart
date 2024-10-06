import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article.dart';

class ArticleListTile extends StatelessWidget {
  final Article article;
  final Function(Article) onBookmarkToggle;

  const ArticleListTile({
    Key? key,
    required this.article,
    required this.onBookmarkToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        article.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(article.description),
      leading: article.urlToImage.isNotEmpty
          ? Image.network(
        article.urlToImage,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image);
        },
      )
          : Icon(Icons.image_not_supported),
      trailing: Obx(() => IconButton(
        icon: Icon(
          article.isBookmarked.value ? Icons.bookmark : Icons.bookmark_border,
          color: article.isBookmarked.value ? Colors.red : null,
        ),
        onPressed: () => onBookmarkToggle(article),
      )),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(article.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (article.urlToImage.isNotEmpty) Image.network(article.urlToImage),
                SizedBox(height: 10),
                Text(article.description),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
