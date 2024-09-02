

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeProvider with ChangeNotifier {

Locale? _appLocale;
Locale? get appLocale => _appLocale;

void changeLanguage(Locale type)async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  _appLocale = type;
  if(type == Locale("en")){
    await sp.setString("language_code", "en");
  }else if(type == Locale("ur")){
    await sp.setString("language_code", "ur");
  }else{
    await sp.setString("language_code", "sd");
  }
  notifyListeners();
}
}

