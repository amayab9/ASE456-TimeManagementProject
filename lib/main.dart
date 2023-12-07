import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'record.dart';
import 'query.dart';
import 'report.dart';
import 'priority.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                recordRoute(context);
              },
              child: const Text('Record Time'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                queryRoute(context);
              },
              child: const Text('Query Time'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                reportRoute(context);
              },
              child: const Text('Report Time'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                priorityRoute(context);
              },
              child: const Text('Priority'),
            ),
          ],
        ),
      ),
    );
  }

  void recordRoute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecordTimePage()),
    );
  }

  void queryRoute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QueryPage()),
    );
  }

  void reportRoute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportPage()),
    );
  }

  void priorityRoute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PriorityPage()),
    );
  }
}

