import 'package:flutter/material.dart';

class Mode with ChangeNotifier{
  late Color background;
  late Color letters;
  late Color widgets;
  late Color widgets_grey;
  bool isLight;

  Mode({this.isLight=false}){
    if(isLight){
      background=Colors.white;
      letters=Colors.black;
      widgets=Colors.blue;
      widgets_grey=Colors.black12;
    }
    else{
      background=Colors.black;
      letters=Colors.white;
      widgets=Colors.black;
      widgets_grey=Colors.white24;
    }
  }

  switchmode(isLight){
    if(isLight){
      background=Colors.white;
      letters=Colors.black;
      widgets=Colors.blue;
      widgets_grey=Colors.black12;
      this.isLight=true;
    }
    else{
      background=Colors.black;
      letters=Colors.white;
      widgets=Colors.black;
      widgets_grey=Colors.white24;
      this.isLight=false;
    }
    notifyListeners();
  }
}
Mode mode=Mode();