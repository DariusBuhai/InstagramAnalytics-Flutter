import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:instagram_analytics/models/user.dart';

import '../utils/network.dart';
import 'package:http/http.dart' as http;

class Favorites extends ChangeNotifier{
  List<String> favorites = [];
  bool loadedItems = false;

  Future<List<String>> load() async {
    if(loggedUser==null){
      return null;
    }
    var response = await http.get(Uri.https(API_URI, "api/get/favorites", {
      "token": loggedUser.token
    }));
    favorites = List<String>.from(jsonDecode(response.body));
    loadedItems = true;
    notifyListeners();
    return favorites;
  }

  Future<List<String>> add(String company) async {
    if(loggedUser==null){
      return null;
    }
    favorites.insert(0, company);
    notifyListeners();
    var _ = await http.post(
        Uri.https(API_URI, "api/post/favorites"),
        body: jsonEncode({
          "token": loggedUser.token,
          "company": company
        })
    );
    return favorites;
  }

  Future<List<String>> delete(String company) async {
    if(loggedUser==null || !favorites.contains(company)){
      return null;
    }
    favorites.remove(company);
    notifyListeners();
    var _ = await http.delete(
        Uri.https(API_URI, "api/delete/favorites"),
        body: jsonEncode({
          "token": loggedUser.token,
          "company": company
        })
    );
    return favorites;
  }
}