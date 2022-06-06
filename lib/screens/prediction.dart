import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/fields/input_field.dart';
import 'package:instagram_analytics/components/page_templates/page_template.dart';
import 'package:instagram_analytics/components/tiles/tile_date_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/alert.dart';
import '../components/tiles/tile_input.dart';
import '../models/user.dart';
import '../utils/functions.dart';

import 'dart:io';

class CompaniesScreen extends StatelessWidget {
  CompaniesScreen({Key key}) : super(key: key);

  List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Predict Posts",
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(top: 10, bottom: 100),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child:  KeyboardActions(
                    config: _buildConfig(context),
                    child: Column(
                      children: [
                        UploadImageComponent(
                          updateUserProfilePicture: () => _updateUserProfilePicture(context),
                        ),
                        const SizedBox(height: 10),
                        InputField(
                          minLines: 3,
                          maxLines: 3,
                          focusNode: focusNodes[0],
                          color: Theme.of(context).cardColor,
                          icon: CupertinoIcons.text_bubble_fill,
                          text: "Post Description",
                          keyboardType: TextInputType.multiline,
                          onChanged: (val){

                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TileDatePicker(
                          text: "Post on:",
                          icon: CupertinoIcons.calendar,
                        ),
                        TileInput(
                          text: "Mean likes:",
                          icon: CupertinoIcons.hand_thumbsup,
                          focusNode: focusNodes[1],
                          keyboardType: TextInputType.number,
                          onChanged: (val){

                          },
                        ),
                        TileInput(
                          text: "Followers:",
                          icon: CupertinoIcons.person_3_fill,
                          focusNode: focusNodes[2],
                          keyboardType: TextInputType.number,
                          onChanged: (val){

                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    )
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: AdaptiveButton(
                  text: "Predict likes",
                  textColor: Colors.white,
                  iconData: CupertinoIcons.percent,
                  onTap: (){

                  },
                ),
              )
            ],
          )
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Theme.of(context).cardColor,
        actions: List.generate(focusNodes.length, (index) {
          return KeyboardActionsItem(
            focusNode: focusNodes[index],
          );
        }));
  }

  void _updateUserProfilePicture(BuildContext context) async {
    File _image;
    final picker = ImagePicker();

    try {
      toggleAdaptiveOverlayLoader(context);
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _cropProfilePicture(_image, context);
      }
      toggleAdaptiveOverlayLoader(context, hide: true);
    } catch (_) {
      alertDialog(
        context,
        title: "Permissions denied",
        subtitle: "Please change photos permissions from settings and try again!",
        confirmText: "Settings",
        onConfirmed: () {
          openAppSettings();
        },
      );
    }
    toggleAdaptiveOverlayLoader(context, hide: true);
  }

  void _cropProfilePicture(File image, BuildContext context) async {
    toggleAdaptiveOverlayLoader(context);
    try {
      File croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Profile Image',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      await loggedUser.updateUserProfilePicture(
          ByteData.view(croppedFile.readAsBytesSync().buffer));
    } catch (_) {}
    toggleAdaptiveOverlayLoader(context, hide: true);
  }
}

class UploadImageComponent extends StatelessWidget{

  final Function() updateUserProfilePicture;

  const UploadImageComponent({Key key, this.updateUserProfilePicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: updateUserProfilePicture,
        child: Container(
          color: Theme.of(context).cardColor,
          width: MediaQuery.of(context).size.width - 30,
          height: MediaQuery.of(context).size.width - 30,
          child: const Center(
            child: Icon(CupertinoIcons.photo_fill_on_rectangle_fill, size: 30),
          ),
        ),
      )

    );
  }

}
