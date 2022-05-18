import 'package:flutter/cupertino.dart';

abstract class ContentsModel<T> extends ChangeNotifier{
  List<T> items = [];
  String search = "";
  bool loadedItems = false;
  Map<String, dynamic> availableFilters = {};
  List availableOrders = [];
  Map<String, dynamic> appliedFilters = {};
  String appliedOrder;
  int totalCount = 0;
  int loaded = 12;
  bool canLoadMoreContents = false;

  List<T> get();

  void loadMore(){
    loaded += 12;
    canLoadMoreContents = loaded < get().length;
    notifyListeners();
  }

  void applyFilters(){
    canLoadMoreContents = loaded < get().length;
    notifyListeners();
  }

  Future<dynamic> load();

  operator [](dynamic id);

}