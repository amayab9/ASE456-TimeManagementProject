import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:individualprojectfinal/main.dart' as app;

import '../documents/design/ver2/firebase_options.dart';

void main() {
  testWidgets('Record Time Page Test', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await tester.pumpWidget(const app.MyApp());

    await tester.tap(find.text('Record Time'));
    await tester.pumpAndSettle();

    await tester.enterText(find.textContaining('Date (YYYY-MM-DD)'), '2023-01-01');
    await tester.enterText(find.textContaining('From-Time (HH:MM AM/PM)'), '12:00 AM');
    await tester.enterText(find.textContaining('To-Time (HH:MM AM/PM)'), '01:00 PM');
    await tester.enterText(find.textContaining('Task'), 'Test Task');
    await tester.enterText(find.textContaining('Tag'), 'Test Tag');

    await tester.tap(find.text('Record Time'));
    await tester.pumpAndSettle();

    expect(find.text('Record submitted successfully.'), findsOneWidget);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('time_records').get();
    expect(querySnapshot.docs.length, greaterThan(0));
    await tester.pumpAndSettle();
  });

  testWidgets('Query Page Test', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await tester.pumpWidget(const app.MyApp());
    await tester.tap(find.text('Query Time'));
    await tester.pumpAndSettle();

    // Select "Date" from the dropdown
    await tester.tap(find.byType(DropdownButton).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Date').last);
    await tester.pumpAndSettle();

    // Enter a date in the text field
    await tester.enterText(find.textContaining('Input'), '2023-01-01');

    // Tap the "Query" button
    await tester.tap(find.text('Query'));
    await tester.pumpAndSettle();

    // Verify that queried data is displayed
    expect(find.text('Queried Data:'), findsOneWidget);

    // Optionally, you can add more assertions to verify the state of your app after querying.

    // Example: Check if the queried data is present in Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('time_records').get();
    expect(querySnapshot.docs.length, greaterThan(0));
    await tester.pumpAndSettle();
  });
}
