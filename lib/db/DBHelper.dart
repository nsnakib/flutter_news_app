import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/article.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'news.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE articles(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT, 
            description TEXT, 
            url TEXT, 
            urlToImage TEXT, 
            isBookmarked INTEGER DEFAULT 0  -- New column for bookmark status
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertArticle(Article article) async {
    final db = await database;
    await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateBookmark(Article article) async {
    final db = await database;
    await db.update(
      'articles',
      article.toMap(),
      where: 'title = ?',
      whereArgs: [article.title],
    );
  }

  Future<List<Article>> getArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('articles');

    return List.generate(maps.length, (i) {
      return Article(
        title: maps[i]['title'],
        description: maps[i]['description'],
        url: maps[i]['url'],
        urlToImage: maps[i]['urlToImage'],
        isBookmarked: maps[i]['isBookmarked'] == 1, // Convert int to bool
      );
    });
  }

  Future<List<Article>> getBookmarkedArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'articles',
      where: 'isBookmarked = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Article(
        title: maps[i]['title'],
        description: maps[i]['description'],
        url: maps[i]['url'],
        urlToImage: maps[i]['urlToImage'],
        isBookmarked: maps[i]['isBookmarked'] == 1, // Convert int to bool
      );
    });
  }

  Future<void> clearArticles() async {
    final db = await database;
    await db.delete('articles');
  }
}
