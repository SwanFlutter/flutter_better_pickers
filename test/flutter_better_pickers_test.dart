import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    final calculator = FlutterBetterPicker(
      maxCount: 3,
      requestType: MyRequestType.image,
    );
    expect(calculator.appbarColor, Colors.red);
    expect(calculator.confirmText, "Album");
    expect(calculator.title, Text("data"));
  });
}
