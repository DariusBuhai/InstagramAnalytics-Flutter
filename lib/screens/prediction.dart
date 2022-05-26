import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_analytics/components/adaptive_loader.dart';
import 'package:instagram_analytics/components/page_templates/main_page_template.dart';

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
