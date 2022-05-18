import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_analytics/components/page_templates/page_template.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../components/adaptive_loader.dart';
import '../models/company.dart';
import '../models/stocks.dart';
import '../utils/functions.dart';
import '../utils/route.dart';

class CompanyScreen extends StatefulWidget {
  final Company company;

  const CompanyScreen({Key key, this.company}) : super(key: key);

  @override
  State<CompanyScreen> createState() => CompanyScreenState();
}

class CompanyScreenState extends State<CompanyScreen> {
  @override
  void initState() {
    asyncInitState();
    super.initState();
  }

  Future<void> asyncInitState() async {
    if (widget.company.articles != null) {
      return;
    }
    await widget.company.loadArticles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: widget.company.name,
      previousPageTitle: "Stocks",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 150,
              child: charts.LineChart(
                  [
                    charts.Series<LinearStocks, int>(
                      id: '1',
                      colorFn: (_, __) => widget.company.stocks.growing
                          ? charts.MaterialPalette.green.shadeDefault
                          : charts.MaterialPalette.red.shadeDefault,
                      domainFn: (LinearStocks sales, _) => sales.day,
                      measureFn: (LinearStocks sales, _) => sales.sales,
                      data: List.generate(widget.company.stocks.stocks.length,
                          (index) {
                        return LinearStocks(
                            index,
                            widget.company.stocks.stocks[index].close -
                                widget.company.stocks.lowest);
                      }),
                    )..setAttribute(charts.rendererIdKey, 'customArea')
                  ],
                  animate: true,
                  customSeriesRenderers: [
                    charts.LineRendererConfig(
                        customRendererId: 'customArea',
                        includeArea: true,
                        roundEndCaps: true),
                  ]),
            ),
          ),
          if (widget.company.articles == null)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Loading articles", style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.normal
                    )),
                    const SizedBox(width: 20),
                    const AdaptiveLoader(radius: 10),
                  ],
                )
              ),
            ),
          if (widget.company.articles != null &&
              widget.company.articles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Articles",
                  style: Theme.of(context).textTheme.headline1),
            ),
          if (widget.company.articles != null)
            Expanded(
                child: SingleChildScrollView(
              primary: false,
              child: Column(
                children:
                    List.generate(widget.company.articles.length, (index) {
                  var article = widget.company.articles[index];
                  if (article == null) {
                    return Container();
                  }
                  return GestureDetector(
                    onTap: () {
                      Routing.openUrl(article.url);
                    },
                    child: Container(
                      width: 1000,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor,
                      ),
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(
                            builder: (_) {
                              if (article.images.isNotEmpty) {
                                var imgUrl = article.images[0];
                                if (!article.images[0].contains("http")) {
                                  imgUrl = "https://www.nytimes.com/$imgUrl";
                                }
                                return CachedNetworkImage(
                                  imageUrl: imgUrl,
                                  height: 300,
                                );
                              }
                              return Container();
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(article.title,
                              style: Theme.of(context).textTheme.subtitle1),
                          const SizedBox(height: 20),
                          Text(article.content,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(limitText(article.by.toString()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColor)),
                              Text(
                                  "Category: ${limitText(article.category.toString())}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColor)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ))
        ],
      ),
    );
  }
}
