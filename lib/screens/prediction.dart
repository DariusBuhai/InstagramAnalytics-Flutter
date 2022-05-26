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
          child: const Center(
            child: AdaptiveLoader(),
          )
      ),
    );
  }
}
