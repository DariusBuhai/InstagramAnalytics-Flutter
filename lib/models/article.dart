import 'dart:convert';

import 'package:instagram_analytics/utils/functions.dart';

class Article{
  final String title;
  final String content;
  final List<dynamic> images;
  final List<dynamic> keywords;
  final String by;
  final DateTime date;
  final String category;
  final String url;

  Article(
      {this.title,
      this.content,
      this.images,
      this.keywords,
      this.by,
      this.date,
      this.category,
      this.url});

  static Article parseFromJson(Map<String, dynamic> jsonData) {
    try {
      return Article(
        title: jsonData["title"],
        content: jsonData["content"],
        images: tryGetDictList(jsonData, "images"),
        keywords: tryGetDictList(jsonData, "keywords"),
        by: jsonData["by"],
        date: parseStringToDateTime(jsonData['date']),
        category: jsonData["category"],
        url: jsonData["url"],
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}