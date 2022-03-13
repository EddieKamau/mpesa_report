import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemingController extends ChangeNotifier {
  ThemingController(){
    prefs.then((value) {
      bool? val = value.getBool('isDarkTheme');
      if(val == null){
        value.setBool('isDarkTheme', false);
      }else{
        isDarkTheme = val;
        notifyListeners();
      }
    });
  }
  Future<SharedPreferences> get prefs async => await SharedPreferences.getInstance();

  bool isDarkTheme = false;

  void changeTheme(bool val)async{
    await (await prefs).setBool('isDarkTheme', val);
    isDarkTheme = val;
    notifyListeners();
  }
}