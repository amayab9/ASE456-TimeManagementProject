import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:individualprojectfinal/main.dart' as app;
import 'package:individualprojectfinal/record.dart';
import '../documents/design/ver2/firebase_options.dart';


void main() {
  testWidgets('Record Time Page Acceptance Test', (WidgetTester tester) async {
    await tester.pumpWidget(const app.MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Record'));
    await tester.pumpAndSettle();
    // Enter valid data into text fields.
    await tester.enterText(find.textContaining('Date'), '2023-12-06');
    await tester.enterText(find.textContaining('From-Time'), '10:00 AM');
    await tester.enterText(find.textContaining('To-Time'), '12:00 PM');
    await tester.enterText(find.textContaining('Task'), 'Sample Task');
    await tester.enterText(find.textContaining('Tag'), 'Sample Tag');

    // Tap the "Record Time" button.
    await tester.tap(find.textContaining('Record Time'));
    await tester.pumpAndSettle();

    // Verify that the record is submitted successfully.
    expect(find.textContaining('Record submitted successfully.'), findsOneWidget);
  });
/*
  testWidgets('Query acc', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await tester.pumpWidget(const app.MyApp());

    await tester.tap(find.text('Query Time'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Date').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.textContaining('Input'), '2023-01-01');

    await tester.tap(find.text('Query'));
    await tester.pumpAndSettle();
    expect(find.text('Queried Data:'), findsOneWidget);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('time_records').get();
    expect(querySnapshot.docs.length, greaterThan(0));
  });

  testWidgets('Report acc', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await tester.pumpWidget(const app.MyApp());
    await tester.tap(find.text('Report Time'));
    await tester.pumpAndSettle();

    await tester.enterText(find.textContaining('Start Date (YYYY-MM-DD)'), '2023-01-01');
    await tester.enterText(find.textContaining('End Date (YYYY-MM-DD)'), '2023-12-31');

    await tester.tap(find.text('Query Data'));
    await tester.pumpAndSettle();

    expect(find.text('Queried Data:'), findsOneWidget);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('time_records').get();
    expect(querySnapshot.docs.length, greaterThan(0));
  });

  testWidgets('Priority acc', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await tester.pumpWidget(const app.MyApp());

    await tester.tap(find.text('Priority'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Generate Priority Report'));
    await tester.pumpAndSettle();

    expect(find.text('Priority Report:'), findsOneWidget);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('time_records').get();
    expect(querySnapshot.docs.length, greaterThan(0));
  });*/
}
