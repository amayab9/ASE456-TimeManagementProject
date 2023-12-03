import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:individualprojectfinal/utils/date_time_utils.dart';
import 'package:individualprojectfinal/utils/constants.dart';

const double spacingAndHeight = 16;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Query Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.spacingAndHeight),
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
            const SizedBox(height: Constants.spacingAndHeight),
            ElevatedButton(
              onPressed: () {
                _queryInformation();
              },
              child: const Text('Query'),
            ),
            const SizedBox(height: Constants.spacingAndHeight),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Constants.blackColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(Constants.spacingAndHeight),
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
        DateTime startOfDay = DateTime(queryDate.year, queryDate.month, queryDate.day);
        DateTime endOfDay = DateTime(queryDate.year, queryDate.month, queryDate.day, 23, 59, 59, 999);
        querySnapshot = await FirebaseFirestore.instance
            .collection('time_records')
            .where('date', isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay)
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
        queriedData.clear();
        querySnapshot = await FirebaseFirestore.instance
            .collection('time_records')
            .where('tag', isEqualTo: query.toLowerCase())
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
    return DateTimeUtils.isValidDateFormat(date);
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateTimeUtils.formatTimestamp(timestamp.toDate());
  }

  String _formatTime(Timestamp timestamp) {
    return DateTimeUtils.formatTime(timestamp);
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
}
