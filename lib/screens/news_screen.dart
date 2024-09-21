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

  @override
  void initState() {
    super.initState();
    news = NewsService().fetchNews();
  }

  Future<void> _refreshNews() async {
    setState(() {
      news = NewsService().fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter News App'),
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final article = snapshot.data![index];
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
