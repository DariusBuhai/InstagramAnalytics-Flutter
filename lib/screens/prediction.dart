import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_analytics/components/buttons/adaptive_button.dart';
import 'package:instagram_analytics/components/fields/input_field.dart';
import 'package:instagram_analytics/components/page_templates/page_template.dart';
import 'package:instagram_analytics/components/tiles/tile_date_picker.dart';
import 'package:instagram_analytics/components/tiles/tile_text.dart';
import 'package:instagram_analytics/models/prediction.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/alert.dart';
import '../components/tiles/tile_input.dart';
import '../models/user.dart';
import '../utils/functions.dart';

import 'dart:io';

class PredictionScreen extends StatelessWidget {
  PredictionScreen({Key key}) : super(key: key);
  PostDetails postDetails = PostDetails();

  List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());

  String prediction = "";

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Predict Posts",
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child:  KeyboardActions(
                    config: _buildConfig(context),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeGreen.withOpacity(.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () => _updateUserProfilePicture(context),
                                    child: Container(
                                      color: Theme.of(context).cardColor,
                                      width: 120,
                                      height: 120,
                                      child: const Center(
                                        child: Icon(CupertinoIcons.photo_fill_on_rectangle_fill, size: 30),
                                      ),
                                    ),
                                  )
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TileInput(
                                      text: "Faces:",
                                      icon: CupertinoIcons.person_alt_circle_fill,
                                      focusNode: focusNodes[0],
                                      keyboardType: TextInputType.number,
                                      value: postDetails.faces.toString(),
                                      autoselect: true,
                                      onChanged: (val){
                                        postDetails.faces = int.tryParse(val);
                                      },
                                    ),
                                    TileInput(
                                      text: "Smiles:",
                                      icon: FontAwesomeIcons.smile,
                                      focusNode: focusNodes[1],
                                      keyboardType: TextInputType.number,
                                      value: postDetails.smiles.toString(),
                                      autoselect: true,
                                      onChanged: (val){
                                        postDetails.smiles = int.tryParse(val);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        InputField(
                          minLines: 3,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          focusNode: focusNodes[2],
                          color: Theme.of(context).cardColor,
                          icon: CupertinoIcons.text_bubble_fill,
                          value: postDetails.description,
                          text: "Post Description",
                          keyboardType: TextInputType.multiline,
                          onChanged: (val){
                            postDetails.description = val;
                          },
                        ),
                        const SizedBox(height: 5,),
                        TileDatePicker(
                          text: "Post datetime:",
                          icon: CupertinoIcons.calendar,
                          value: postDetails.postedOn,
                          onChanged: (newDate){
                            postDetails.postedOn = newDate;
                          },
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemRed.withOpacity(.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              AdaptiveButton(
                                text: "Connect instagram account    +",
                                iconData: FontAwesomeIcons.instagram,
                                color: CupertinoColors.black,
                                textColor: Colors.white,
                                onTap: (){

                                },
                              ),
                              const SizedBox(height: 5),
                              TileInput(
                                text: "Mean likes:",
                                icon: CupertinoIcons.hand_thumbsup,
                                focusNode: focusNodes[3],
                                keyboardType: TextInputType.number,
                                value: postDetails.meanLikes.toString(),
                                autoselect: true,
                                onChanged: (val){
                                  postDetails.meanLikes = int.tryParse(val);
                                },
                              ),
                              TileInput(
                                text: "Followers:",
                                icon: CupertinoIcons.person_3_fill,
                                focusNode: focusNodes[4],
                                keyboardType: TextInputType.number,
                                autoselect: true,
                                value: postDetails.followers.toString(),
                                onChanged: (val){
                                  postDetails.followers = int.tryParse(val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        AdaptiveButton(
                          text: "Predict likes",
                          textColor: Colors.white,
                          iconData: CupertinoIcons.percent,
                          onTap: () async{
                            var response = await postDetails.predictLikes();
                            alertDialog(context, title: "Prediction:", subtitle: "Your post will get aprox.: ${response['likes']} likes, representing ${response['likes_over_mean']} of total likes mean.");
                          },
                        ),
                        const SizedBox(height: 10),
                        Text("Prediction: 100 likes, 0.22 likes/mean",textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),),
                        const SizedBox(height: 120),
                      ],
                    )
                ),
              ),
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