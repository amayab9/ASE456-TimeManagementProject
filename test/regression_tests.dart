import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:individualprojectfinal/utils/date_time_utils.dart';
import 'package:individualprojectfinal/main.dart' as app;

void main() {
  group('DateTimeUtils Tests', () {
    test('formatTimestamp should return formatted timestamp', () {
      DateTime dateTime = DateTime(2023, 1, 1, 12, 0);
      expect(DateTimeUtils.formatTimestamp(dateTime), '2023-01-01 12:00');
    });

    test('isValidDateFormat should return true for valid date format', () {
      expect(DateTimeUtils.isValidDateFormat('2023-01-01'), true);
    });

    test('isValidDateFormat should return false for invalid date format', () {
      expect(DateTimeUtils.isValidDateFormat('2023/01/01'), false);
    });
  });

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

