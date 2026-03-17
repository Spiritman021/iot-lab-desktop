import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iot_lab_desktop/main.dart';

void main() {
  testWidgets('IoT Lab app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const IoTLabApp());
    // Just test that the app renders without error
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
