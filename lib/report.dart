import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<ReportPage> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  List<String> queriedData = [];


  Future<void> _reportData(String startDate, String endDate) async {
    try {
      QuerySnapshot querySnapshot;
      startDateController.clear();
      endDateController.clear();

      if (!_isValidDateFormat(startDate) || !_isValidDateFormat(endDate)) {
        setState(() {
          queriedData.clear();
          queriedData.add('Invalid date format');
        });
        return;
      }

      DateTime queryDate = DateTime.parse(startDate);
      querySnapshot = await FirebaseFirestore.instance
          .collection('time_records')
          .where('date', isGreaterThanOrEqualTo: DateTime.parse(startDate), isLessThanOrEqualTo: DateTime.parse(endDate))
          .get();
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
        startDateController.clear();
        endDateController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Report Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: startDateController,
              decoration: const InputDecoration(
                labelText: 'Start Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'End Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _reportData(startDateController.text, endDateController.text);
              },
              child: const Text('Query Data'), // Changed the button text
            ),
            const SizedBox(height: 16.0), // Added a comma here
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
                    ),
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

