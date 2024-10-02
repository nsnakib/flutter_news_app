import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleListTile extends StatelessWidget {
  final Article article;

  const ArticleListTile({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        article.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(article.description),
      leading: article.urlToImage.isNotEmpty // Check if the image URL is valid
          ? Image.network(
        article.urlToImage,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image); // Handle invalid image URLs
        },
      )
          : Icon(Icons.image_not_supported), // Placeholder if no image available
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(article.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (article.urlToImage.isNotEmpty)
                  Image.network(article.urlToImage),
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
