import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/page_templates/main_page_template.dart';

import '../components/adaptive_loader.dart';
import '../models/company.dart';
import '../models/favorites.dart';
import '../models/user.dart';
import '../utils/route.dart';
import 'auth/auth.dart';
import 'prediction.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loggedUser != null) {
      return MainPageTemplate(
        title: "Favorites",
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.only(top: 10, bottom: 100),
            child: Consumer<Companies>(
              builder: (context, _, __) {
                return Consumer<Favorites>(
                  builder: (context, __, ___) {
                    if (!Provider.of<Favorites>(context).loadedItems) {
                      return const Center(
                        child: AdaptiveLoader(),
                      );
                    }
                    return Column(
                      children: List.generate(
                          Provider.of<Favorites>(context).favorites.length,
                          (index) => CompanyPreview(
                                company: Provider.of<Companies>(context)[Provider.of<Favorites>(context).favorites[index]],
                              )),
                    );
                  },
                );
              },
            )),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("You are not sign in",
                style: Theme.of(context).textTheme.headline2),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  "In order to create favorites, please sign in or create an account.",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .color
                          .withOpacity(.4))),
            ),
            const SizedBox(height: 30),
            AdaptiveButton(
              text: "Sign in to continue",
              iconData: CupertinoIcons.square_arrow_right,
              textColor: Colors.white,
              onTap: () async {
                Routing.openReplacementRoute(context, const AuthPage());
              },
            )
          ],
        ),
      ),
    );
  }
}
