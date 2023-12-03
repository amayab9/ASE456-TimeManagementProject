import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PriorityPage extends StatefulWidget {
  const PriorityPage({Key? key}) : super(key: key);

  @override
  _PriorityState createState() => _PriorityState();
}

class _PriorityState extends State<PriorityPage> {
  List<Map<String, dynamic>> queriedData = [];

  Future<void> _reportData() async {
    try {
      QuerySnapshot querySnapshot;
      Map<String, int> taskCountMap = {};

      querySnapshot = await FirebaseFirestore.instance.collection('time_records').get();

      //retrieve data for each doc
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          String task = data['task'];
          taskCountMap[task] = (taskCountMap[task] ?? 0) + 1;
        }
      }

      // sort tasks
      List<MapEntry<String, int>> sortedTaskList = taskCountMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // task and count
      setState(() {
        queriedData.clear();
        for (var entry in sortedTaskList) {
          String task = entry.key;
          int count = entry.value;

          // add task and count as a map to queriedData
          queriedData.add({'task': task, 'count': count});
        }
      });

    } catch (error) {
      setState(() {
        queriedData.add({'error': 'Error: $error'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Priority'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _reportData();
                },
                child: const Text('Generate Priority Report'),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Priority Report: '),
                      const SizedBox(height: 8.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Task'),
                          Text('Occurrences'),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: queriedData.map((data) {
                              if (data.containsKey('error')) {
                                return Text(data['error']);
                              } else {
                                String task = data['task'];
                                task = task.length > 50 ? '${task.substring(0, 50)}...' : task;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(task),
                                    Text(data['count'].toString()),
                                  ],
                                );
                              }
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
