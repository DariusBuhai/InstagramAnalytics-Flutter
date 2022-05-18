import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instagram_analytics/models/stocks.dart';
import '../utils/network.dart';
import 'article.dart';
import 'contents_model.dart';

class Company{
  final String code;
  final String name;
  final String description;
  final Stocks stocks;

  List<Article> articles;

  Company({this.code, this.name, this.description, this.stocks});

  static Company parseFromJson(Map<String, dynamic> jsonData) {
    try {
      return Company(
        code: jsonData["code"],
        name: jsonData["name"],
        description: jsonData["description"],
        stocks: Stocks.parseFromJson(jsonData['stocks'])
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> loadArticles() async{
    var response = await http.get(
        Uri.https(API_URI, "api/get/articles", {
          "company": code
        }));
    var articlesJson = jsonDecode(response.body);
    articles = [];
    for (var articleJson in articlesJson) {
      articles.add(Article.parseFromJson(articleJson));
    }
  }

}


class Companies extends ContentsModel{

  @override
  operator [](dynamic id) {
    return items.firstWhere((element) => element.code==id);
  }

  @override
  List get() {
    return items;
  }

  @override
  Future<dynamic> load() async {
    var response = await http.get(
        Uri.https(API_URI, "api/get/companies"));
    var companiesJson = jsonDecode(response.body);
    items = [];
    for (var companyJson in companiesJson) {
      items.add(Company.parseFromJson(companyJson));
    }
    loadedItems = true;
    notifyListeners();
    return items;
  }

}
