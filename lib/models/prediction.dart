import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/network.dart';

class PostDetails{
  String description;
  int meanLikes, followers;
  DateTime postedOn;
  int faces, smiles;

  PostDetails(
      {this.description = "",
      this.meanLikes = 0,
      this.postedOn,
      this.followers = 0,
      this.faces = 0,
      this.smiles = 0}){
    postedOn = DateTime.now();
  }

  Map<String, dynamic> toJson(){
    return {
      "description": description,
      "mean_likes": meanLikes,
      "faces": faces,
      "smiles": smiles,
      "datetime": (postedOn.millisecondsSinceEpoch / 1000).floor(),
      "followers": followers,
    };
  }

  Future<dynamic> predictLikes() async{
    print(toJson());
    var response = await http.get(Uri.http(API_URI, "api/get/predict_likes", toJson().map((key, value) => MapEntry(key, value.toString()))));
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    return NetworkError();
  }
}