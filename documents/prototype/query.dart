import 'dart:js_interop';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QueryPage extends StatefulWidget {
  const QueryPage({Key? key}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  TextEditingController queryController = TextEditingController();
  String? dropdownValue;
  List<String> queriedData = [];
  DateTime? selectedDate;

  Future<void> _performQuery(String query) async {
    try {
      QuerySnapshot querySnapshot;
      queryController.clear();
      if (dropdownValue == 'today') {
        if (!_isValidDateFormat(query)) {
          setState(() {
            queriedData.clear();
            queriedData.add('Invalid date format');
          });
          return;
        }
        DateTime queryDate = DateTime.parse(query);
        querySnapshot = await FirebaseFirestore.instance
            .collection('time_records')
            .where('date', isEqualTo: queryDate)
            .get();
      } else if (dropdownValue == 'date') {
        if (!_isValidDateFormat(query)) {
          setState(() {
            queriedData.clear();
            queriedData.add('Invalid date format');
          });
          return;
        }
        DateTime queryDate = DateTime.parse(query);
        querySnapshot = await FirebaseFirestore.instance
            .collection('time_records')
            .where('date', isEqualTo: queryDate)
            .get();
      } else if (dropdownValue == 'task') {
        queriedData.clear();
        querySnapshot = await FirebaseFirestore.instance
            .collection('time_records')
            .where('task', isGreaterThanOrEqualTo: query.toLowerCase(), isLessThan: '${query.toLowerCase()}z')
            .get();
      } else if (dropdownValue == 'tag') {
        // Query by task

        queriedData.clear();
        querySnapshot = await FirebaseFirestore.instance
            .collection('time_records')
            .where('tag', isGreaterThanOrEqualTo: query.toLowerCase(), isLessThan: '${query.toLowerCase()}z')
            .get();
      } else {
        setState(() {
          queriedData.clear();
          queriedData.add('Invalid input');
        });
        return;
      }

      setState(() {
        queriedData.clear();
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data != null) {
            String formattedDate = _formatTimestamp(data['date']);
            String formattedToTime = _formatTime(data['toTime']);
            String formattedFromTime = _formatTime(data['fromTime']);
            String formattedData =
                "Date: $formattedDate, To Time: $formattedToTime, From Time: $formattedFromTime, Task: ${data['task']}, Tag: ${data['tag']}";
            queriedData.add(formattedData);
          }
        }
      });
    } catch (error) {
      setState(() {
        queriedData.clear();
        queriedData.add('Error: $error');
      });
    }
  }

  bool _isValidDateFormat(String date) {
    RegExp dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return dateRegExp.hasMatch(date);
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(Timestamp timestamp) {
    DateTime time = timestamp.toDate();
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _queryInformation() {
    if (dropdownValue == 'today') {
      DateTime today = DateTime.now();
      String formattedToday = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      _performQuery(formattedToday);
    } else if (dropdownValue == 'date') {
      if (_isValidDateFormat(queryController.text)) {
        _performQuery(queryController.text);
      } else {
        setState(() {
          queriedData.clear();
          queriedData.add('Invalid date format');
        });
      }
    } else if (dropdownValue == 'task' || dropdownValue == 'tag') {
      _performQuery(queryController.text);
    } else {
      setState(() {
        queriedData.clear();
        queriedData.add('Invalid input');
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Query Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Query by: '),
            DropdownButton(
              value: dropdownValue,
              items: const [
                DropdownMenuItem(
                  value: 'today',
                  child: Text('Today'),
                ),
                DropdownMenuItem(
                  value: 'date',
                  child: Text('Date'),
                ),
                DropdownMenuItem(
                  value: 'task',
                  child: Text('Task'),
                ),
                DropdownMenuItem(
                  value: 'tag',
                  child: Text('Tag'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value;
                  if (value == 'task' || value == 'tag') {
                    queryController.clear();
                  }
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: queryController,
                    decoration: const InputDecoration(
                      labelText: 'Input',
                    ),
                    enabled: dropdownValue != 'today',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _queryInformation();
              },
              child: const Text('Query'),
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
                    const Text('Queried Data: '),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: queriedData.map((data) => Text(data)).toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
