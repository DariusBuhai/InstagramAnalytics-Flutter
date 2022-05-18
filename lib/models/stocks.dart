import 'dart:math';

class LinearStocks {
  final int day;
  final double sales;

  LinearStocks(this.day, this.sales);
}

class Stock {
  final DateTime date;
  final double open, close, high, low;

  Stock({this.date, this.open, this.close, this.high, this.low});

  static Stock parseFromJson(Map<String, dynamic> jsonData) {
    try {
      return Stock(
        // date: jsonData["code"],
        open: jsonData["open"],
        close: jsonData["close"],
        high: jsonData["high"],
        low: jsonData["low"],
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class Stocks {
  List<Stock> stocks = [];
  bool growing = false;
  double growth = 0;
  double lowest = 9999999, highest = 0;

  void add(Stock stock){
    stocks.add(stock);
    lowest = min(lowest, stock.close);
    highest = max(highest, stock.close);
    if(stocks.length>1){
      growth = 1 - stocks[0].close / stocks[stocks.length-1].close;
    }
    if(growth>0){
      growing = true;
    }
  }

  static Stocks parseFromJson(List<dynamic> jsonData) {
    try {
      Stocks _stocks = Stocks();
      for(var stock in jsonData){
        _stocks.add(Stock.parseFromJson(stock));
      }
      return _stocks;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
