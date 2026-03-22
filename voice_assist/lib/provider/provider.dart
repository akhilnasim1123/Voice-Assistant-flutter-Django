
import 'package:flutter/material.dart';

class ContentProvider extends ChangeNotifier {
  String content = "";

  String get message => content;

  void updateMessage(String newContent) {
    content = newContent;
    notifyListeners();
  }
}