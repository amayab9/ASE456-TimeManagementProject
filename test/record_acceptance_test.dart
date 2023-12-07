import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:individualprojectfinal/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Mock class for FirebaseFirestore
class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  testWidgets('RecordTimePage acceptance test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: RecordTimePage(),
      ),
    );

    // Ensure the Record Time button is present.
    expect(find.text('Record Time'), findsOneWidget);

    // Mocking Firestore instance
    final mockFirestore = MockFirestore();

    // Set up the mock to return a successful result when saving time record
    when(mockFirestore.collection('time_records').add(any)).thenAnswer(
          (_) => Future.value(DocumentReference(mockFirestore, '1')),
    );

    // Tap the Record Time button.
    await tester.tap(find.text('Record Time'));
    await tester.pump();

    // Verify that the saveTimeRecord method is called.
    verify(mockFirestore.collection('time_records').add(captureAny)).called(1);

    // Extract the captured argument (record data)
    Map<String, dynamic> capturedRecord = verify(mockFirestore.collection('time_records').add(captureAny)).captured.first;

    // Verify that the text controllers are cleared after submitting.
    expect((tester.widget(find.byType(TextFormField).at(0)) as TextFormField).controller!.text, '');
    expect((tester.widget(find.byType(TextFormField).at(1)) as TextFormField).controller!.text, '');
    expect((tester.widget(find.byType(TextFormField).at(2)) as TextFormField).controller!.text, '');
    expect((tester.widget(find.byType(TextFormField).at(3)) as TextFormField).controller!.text, '');
    expect((tester.widget(find.byType(TextFormField).at(4)) as TextFormField).controller!.text, '');

    // Verify that the success snackbar is displayed.
    expect(find.text('Record submitted successfully.'), findsOneWidget);

    // Verify that the error snackbar is not displayed.
    expect(find.text('Failed to submit record'), findsNothing);

    // Verify the structure of the captured record data
    expect(capturedRecord['date'], isA<Timestamp>());
    expect(capturedRecord['fromTime'], isA<Timestamp>());
    expect(capturedRecord['toTime'], isA<Timestamp>());
    expect(capturedRecord['task'], 'Task Value');
    expect(capturedRecord['tag'], 'Tag Value');
  });
}
