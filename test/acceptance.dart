import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:individualprojectfinal/main.dart' as app;

void main() {
  testWidgets('App Acceptance Test', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MyApp());

    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Record Time'));
    await tester.pumpAndSettle();

    expect(find.textContaining('From-Time'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Query Time'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Query Time'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Priority'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Task'), findsOneWidget);

  });
}
