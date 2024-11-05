import 'package:flutter/material.dart';

class MyMenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 1;
  int get index => _index;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void closeDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
  _scaffoldKey.currentState!.closeDrawer();
}
  }
  

  void changePage(int current) {
    _index = current;
    notifyListeners();
  }
}