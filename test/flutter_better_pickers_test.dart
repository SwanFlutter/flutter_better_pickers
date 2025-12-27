import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FlutterBetterPicker initialization test', () {
    final picker = FlutterBetterPicker(
      maxCount: 5,
      requestType: MyRequestType.all,
      labels: PickerLabels.english,
      style: PickerStyle.dark,
    );
    expect(picker.maxCount, 5);
    expect(picker.requestType, MyRequestType.all);
    expect(picker.labels, PickerLabels.english);
    expect(picker.style, PickerStyle.dark);
  });

  test('PickerLabels test', () {
    expect(PickerLabels.english.confirmButtonText, 'Send');
    expect(PickerLabels.persian.confirmButtonText, 'ارسال');
    expect(PickerLabels.arabic.confirmButtonText, 'إرسال');
    expect(PickerLabels.spanish.confirmButtonText, 'Enviar');
    expect(PickerLabels.chinese.confirmButtonText, '发送');
  });

  test('PickerStyle test', () {
    expect(PickerStyle.dark.backgroundColor, const Color(0xFF1E1E1E));
    expect(PickerStyle.light.backgroundColor, Colors.white);
    expect(PickerStyle.telegram.backgroundColor, const Color(0xFF17212B));
    expect(PickerStyle.instagram.backgroundColor, const Color(0xFF121212));
  });
}
