import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    final calculator = FlutterBetterPicker(
      maxCount: 5,
      requestType: MyRequestType.all,
    );
    expect(calculator.appbarColor, 0xFF6A0DAD);
    expect(calculator.confirmText, 'Send');
  });
}
