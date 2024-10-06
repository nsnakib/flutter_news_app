import 'package:get/get.dart';
import '../models/article.dart';
import '../services/news_service.dart';

class NewsController extends GetxController {
  var allArticles = <Article>[].obs;
  var filteredArticles = <Article>[].obs;
  var bookmarkedArticles = <Article>[].obs;
  var searchQuery = "".obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      var articles = await NewsService().fetchNews();
      allArticles.assignAll(articles);
      filteredArticles.assignAll(articles);
    } finally {
      isLoading.value = false;
    }
  }

  void filterArticles(String query) {
    searchQuery.value = query.toLowerCase();
    filteredArticles.assignAll(allArticles.where((article) {
      return article.title.toLowerCase().contains(searchQuery.value) ||
          article.description.toLowerCase().contains(searchQuery.value);
    }).toList());
  }

  void toggleBookmark(Article article) {
    article.isBookmarked.value = !article.isBookmarked.value;

    if (article.isBookmarked.value) {
      bookmarkedArticles.add(article);
    } else {
      bookmarkedArticles.remove(article);
    }
  }
}
