import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_analytics/components/adaptive_loader.dart';
import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/page_templates/main_page_template.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:instagram_analytics/models/user.dart';
import '../models/company.dart';
import '../models/favorites.dart';
import '../models/stocks.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPageTemplate(
      title: "Predict Posts",
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(top: 10, bottom: 100),
          child: Consumer<Companies>(
            builder: (context, __, ___) {
              if (!Provider.of<Companies>(context).loadedItems) {
                return const Center(
                  child: AdaptiveLoader(),
                );
              }
              return Column(
                children: List.generate(
                    Provider.of<Companies>(context).get().length,
                    (index) => CompanyPreview(
                          company: Provider.of<Companies>(context).get()[index],
                        )),
              );
            },
          )
      ),
    );
  }
}

class CompanyPreview extends StatelessWidget {
  final Company company;

  const CompanyPreview({Key key, @required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      width: 100000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(company.name,
                      style: Theme.of(context).textTheme.headline5),
                  Text(company.code,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .color
                              .withOpacity(.5))),
                ],
              ),
              if (loggedUser != null)
                Consumer<Favorites>(
                  builder: (context, _, __){
                    bool isFavorite = Provider.of<Favorites>(context).favorites.contains(company.code);
                    return SizedBox(
                      width: 30,
                      height: 30,
                      child: AdaptiveButton(
                        textColor: isFavorite ? Colors.white : CupertinoColors.systemOrange,
                        iconData: Icons.star,
                        color: isFavorite ? CupertinoColors.systemOrange : Theme.of(context).cardColor,
                        borderColor: CupertinoColors.systemOrange,
                        borderRadius: 40,
                        onTap: () {
                          if(!isFavorite){
                            Provider.of<Favorites>(context, listen: false).add(company.code);
                          }else{
                            Provider.of<Favorites>(context, listen: false).delete(company.code);
                          }
                        },
                      ),
                    );
                  },
                ),
              if (loggedUser == null)
                const SizedBox()
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: charts.LineChart(
                [
                  charts.Series<LinearStocks, int>(
                    id: '1',
                    colorFn: (_, __) => company.stocks.growing
                        ? charts.MaterialPalette.green.shadeDefault
                        : charts.MaterialPalette.red.shadeDefault,
                    domainFn: (LinearStocks sales, _) => sales.day,
                    measureFn: (LinearStocks sales, _) => sales.sales,
                    data:
                    List.generate(company.stocks.stocks.length, (index) {
                      return LinearStocks(
                          index,
                          company.stocks.stocks[index].close -
                              company.stocks.lowest);
                    }),
                  )..setAttribute(charts.rendererIdKey, 'customArea')
                ],
                animate: true,
                customSeriesRenderers: [
                  charts.LineRendererConfig(
                    customRendererId: 'customArea',
                    includeArea: true,
                    stacked: true,
                    roundEndCaps: true,
                  ),
                ]),
          ),
          const SizedBox(height: 10),

        ],
      ),
    );
  }
}
