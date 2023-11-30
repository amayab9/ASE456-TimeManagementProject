import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:individualprojectfinal/main.dart';


void main() {

  testWidgets('Ensure buttons appear', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Record Time'), findsOneWidget);
    expect(find.text('Query Time'), findsOneWidget);
    expect(find.text('Report Time'), findsOneWidget);
    expect(find.text('Priority'), findsOneWidget);

  }, tags: 'main');

  testWidgets('Navigate to Record Page and verify page loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Record Time'), findsOneWidget);
    await tester.tap(find.text('Record Time'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Date'), findsOneWidget);
    expect(find.textContaining('From-Time'), findsOneWidget);
    expect(find.textContaining('To-Time'), findsOneWidget);
    expect(find.text('Task'), findsOneWidget);
    expect(find.text('Tag'), findsOneWidget);

  }, tags: 'record');

  testWidgets('Navigate to Query Page and verify page loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Query Time'), findsOneWidget);
    await tester.tap(find.text('Query Time'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Query by:'), findsOneWidget);
    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Query'), findsOneWidget);
    expect(find.textContaining('Queried Data:'), findsOneWidget);

  }, tags: 'Query');

  testWidgets('Navigate to Report Page and verify page loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Report Time'), findsOneWidget);
    await tester.tap(find.text('Report Time'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Start'), findsOneWidget);
    expect(find.textContaining('End'), findsOneWidget);
    expect(find.textContaining('Query Data'), findsOneWidget);
    expect(find.textContaining('Queried Data:'), findsOneWidget);

  }, tags: 'Report');

  testWidgets('Navigate to Priority Page and verify page loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Priority'), findsOneWidget);
    await tester.tap(find.text('Priority'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Generate'), findsOneWidget);
    expect(find.textContaining('Priority Report:'), findsOneWidget);
    expect(find.textContaining('Task'), findsOneWidget);
    expect(find.textContaining('Occurrences'), findsOneWidget);

  }, tags: 'Report');

}
