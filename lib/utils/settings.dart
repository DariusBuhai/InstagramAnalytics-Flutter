import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier{

  bool _darkMode = false;
  bool _switchAutomatically = false;

  Future<bool> getDarkMode() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("DARK_MODE") ?? false;
  }

  Future<bool> getSwitchAutomatically() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("SWITCH_AUTOMATICALLY") ?? false;
  }

  void onChangePlatformBrightness(Brightness platformBrightness){
    if(this._switchAutomatically)
      this.darkMode = platformBrightness == Brightness.dark;
  }

  Future<void> initSettings() async{
    this._switchAutomatically = await this.getSwitchAutomatically();
    this._darkMode = await this.getDarkMode();
    this.notifyListeners();
  }

  get darkMode => _darkMode;
  get switchAutomatically => _switchAutomatically;

  set darkMode(bool value){
    SharedPreferences.getInstance().then((prefs){
      prefs.setBool("DARK_MODE", value);
      this._darkMode = value;
      this.notifyListeners();
    });
  }

  set switchAutomatically(bool value) {
    if(value)
      this.darkMode = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    SharedPreferences.getInstance().then((prefs){
      prefs.setBool("SWITCH_AUTOMATICALLY", value);
      this._switchAutomatically = value;
      this.notifyListeners();
    });
  }

}