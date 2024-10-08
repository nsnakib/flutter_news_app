import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'BookmarkedArticlesScreen.dart';
import 'Detail/ArticleDetailScreen.dart';
import 'controllers/NewsController.dart';
import 'screens/news_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the NewsController
    Get.put(NewsController());

    return GetMaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => NewsScreen(),
          children: [
            GetPage(
              name: '/articleDetails',
              page: () => ArticleDetailScreen(),
            ),
            GetPage(
              name: '/bookmarked',
              page: () => BookmarkedArticlesScreen(),
              children: [
                GetPage(
                  name: '/articleDetails',
                  page: () => ArticleDetailScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
