// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fraud_detection_app/main.dart';

void main() {
  testWidgets('App loads transaction step 1 screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FraudDetectionApp());

    // Verify that the first screen loads with the correct title
    expect(find.text('New Transaction (1/2)'), findsOneWidget);
    expect(find.text('Transaction Details'), findsOneWidget);
    expect(find.text('Amount (USD)'), findsOneWidget);
  });
}
