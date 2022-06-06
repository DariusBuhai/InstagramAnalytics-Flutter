import 'package:instagram_analytics/screens/auth/auth.dart';
import 'package:instagram_analytics/components/page_templates/blank_page_template.dart';
import 'package:instagram_analytics/components/alert.dart';
import 'package:instagram_analytics/components/terms_conditions.dart';
import 'package:instagram_analytics/components/tiles/tile_button.dart';
import 'package:instagram_analytics/components/tiles/tile_text.dart';
import 'package:instagram_analytics/models/user.dart';
import 'package:instagram_analytics/screens/profile_settings.dart';
import 'package:instagram_analytics/tabbed_app.dart';
import 'package:instagram_analytics/utils/route.dart';
import 'package:instagram_analytics/utils/settings.dart';
import 'package:instagram_analytics/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'change_password.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlankPageTemplate(
      onRefresh: _onRefresh,
      child: _UserOptions(

      ),
    );
  }

  void _onRefresh() async {
    HapticFeedback.mediumImpact();
    await loggedUser.reloadUser();
  }

}

class _UserOptions extends StatelessWidget {
  final Function updateUserProfilePicture;
  List<FocusNode> focusNodes = List.generate(1, (_) => FocusNode());

  _UserOptions({Key key, this.updateUserProfilePicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(loggedUser!=null)
            Consumer<User>(
              builder: (_, __, ___) =>  _UserName(),
            ),
          if (loggedUser != null) const SizedBox(height: 30),
          TileText(text: "Account details"),
          if (loggedUser != null && loggedUser.loginType == 'email')
            TileButton(
              text: "Update password",
              icon: CupertinoIcons.lock,
              onTap: () {
                Routing.openAnimatedRoute(context, const ChangePasswordPage());
              },
            ),
          if (loggedUser != null)
            TileButton(
                text: "Edit Profile logo",
                icon: CupertinoIcons.camera,
                leading: Container(),
                onTap: () => updateUserProfilePicture()),
          if (loggedUser != null)
            TileButton(
              text: "Profile Settings",
              icon: CupertinoIcons.rectangle_stack_person_crop,
              onTap: () async {
                Routing.openAnimatedRoute(context, const UserDetailsScreen());
              },
              leading: Container(),
            ),
          if (loggedUser == null)
            TileButton(
              text: "Sign in or create an account",
              icon: CupertinoIcons.square_arrow_right,
              onTap: () async {
                Routing.openReplacementRoute(context, const AuthPage());
              },
              leading: Container(),
            ),
          if (loggedUser != null)
            TileButton(
              text: "Sign out",
              icon: CupertinoIcons.square_arrow_left,
              onTap: () async {
                await loggedUser.logOut();
                Routing.openReplacementRoute(context, const TabbedApp(initialPage: 2));
              },
              leading: Container(),
            ),
          if (loggedUser != null)
            TileButton(
              text: "Delete account",
              icon: CupertinoIcons.trash,
              leading: Container(),
              onTap: () {
                alertDialog(context, alertId: "delete_account",
                    onConfirmed: () async {
                  await loggedUser.delete();
                  Routing.openReplacementRoute(context, const TabbedApp(initialPage: 2));
                });
              },
            ),
          TileText(text: "Settings"),
          TileButton(
            text: "Dark mode",
            icon: CupertinoIcons.moon_stars,
            leading: Switch.adaptive(
                activeColor: Theme.of(context).primaryColor,
                value: Provider.of<Settings>(context).darkMode,
                onChanged: (value) {
                  Provider.of<Settings>(context, listen: false).darkMode =
                      value;
                  Provider.of<Settings>(context, listen: false)
                      .switchAutomatically = false;
                }),
          ),
          TileButton(
            text: "Switch automatically",
            icon: CupertinoIcons.brightness_solid,
            leading: Switch.adaptive(
                value: Provider.of<Settings>(context).switchAutomatically,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  Provider.of<Settings>(context, listen: false)
                      .switchAutomatically = value;
                }),
          ),
          TileText(text: "More"),
          TileButton(
            text: "Rate app",
            icon: CupertinoIcons.star_circle,
            onTap: () async {
              if (await InAppReview.instance.isAvailable()) {
                InAppReview.instance.requestReview();
              }
            },
            leading: Container(),
          ),
          const SizedBox(height: 10),
          TermsConditions(leadingText: ""),
          const SizedBox(height: 120)
        ],
      ),
    );
  }
}

class _UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(loggedUser.username ?? '',
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.headline1.copyWith(fontSize: 40)),
        const SizedBox(height: 5),
        Text(
          loggedUser.email,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 12),
        )
      ],
    );
  }
}

class _UserImage extends StatelessWidget {
  final Function updateUserProfilePicture;

  const _UserImage({Key key, @required this.updateUserProfilePicture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Center(
                child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      spreadRadius: 4,
                                      blurRadius: 10)
                                ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Builder(
                                builder: (context) {
                                  if (loggedUser.image != null) {
                                    return Image.memory(
                                      loggedUser.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Container(
                                            color: Theme.of(context).cardColor);
                                      },
                                    );
                                  }
                                  return Container(
                                      color: Theme.of(context).cardColor);
                                },
                              ),
                            ),
                          ),
                          onTap: updateUserProfilePicture,
                        ),
                        (loggedUser.image != null)
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: FlatButton(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    )),
                                    color: Theme.of(context).primaryColor,
                                    onPressed: updateUserProfilePicture,
                                    padding: EdgeInsets.zero,
                                    child: const Icon(
                                      CupertinoIcons.camera_on_rectangle,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              )
                            : ClipRRect(
                                child: Center(
                                    child: IconButton(
                                  onPressed: updateUserProfilePicture,
                                  icon: Icon(
                                    CupertinoIcons.camera,
                                    color: Theme.of(context).primaryColorLight,
                                    size: 30,
                                  ),
                                )),
                              ),
                      ],
                    )))
          ],
        ),
      ),
      onTap: updateUserProfilePicture,
    );
  }
}
