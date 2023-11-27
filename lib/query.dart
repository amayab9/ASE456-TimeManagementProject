import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QueryPage extends StatefulWidget {
  const QueryPage({Key? key}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Query Time'),
      ),
      body: const Center(
        child: Text(
          'query coming soon',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}