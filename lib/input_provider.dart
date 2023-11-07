import 'package:flutter/material.dart';

class InputModel extends ChangeNotifier {
  final List<String> _barcode = [""];

  List<String> get barcode => _barcode;

  void setBarcode(List<String> barcode) {
    _barcode.clear();
    _barcode.addAll(barcode);
    notifyListeners();
  }

  void addBarcode(String value) {
    _barcode.add(value);
    notifyListeners();
  }

  void removeBarcode(int index) {
    _barcode.removeAt(index);
    notifyListeners();
  }
}
