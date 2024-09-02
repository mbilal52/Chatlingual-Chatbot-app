


import 'package:flutter/cupertino.dart';

class LoadingProvider with ChangeNotifier{

  bool _loading = false;
  bool get loading => loading;

  void setLoading(){
    _loading = true;
    notifyListeners();
  }
}