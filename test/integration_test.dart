import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:individualprojectfinal/main.dart' as app;

void main() {
  testWidgets('Integration Test start up', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MyApp());
    expect(find.text('Record Time'), findsOneWidget);
    expect(find.text('Query Time'), findsOneWidget);
    expect(find.text('Report Time'), findsOneWidget);
    expect(find.text('Priority'), findsOneWidget);
  });

  testWidgets('Navigate to page - record', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MyApp());
    expect(find.text('Record Time'), findsOneWidget);
    await tester.tap(find.text('Record Time'));
  });

  testWidgets('Navigate to page - query', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MyApp());
    expect(find.text('Query Time'), findsOneWidget);
    await tester.tap(find.text('Query Time'));
  });

  testWidgets('Navigate to page - report', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MyApp());
    expect(find.text('Report Time'), findsOneWidget);
    await tester.tap(find.text('Report Time'));
  });

  testWidgets('Navigate to page - priority', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MyApp());
    expect(find.text('Priority'), findsOneWidget);
    await tester.tap(find.text('Priority'));
  });
}
