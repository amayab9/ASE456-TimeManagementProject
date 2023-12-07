import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:individualprojectfinal/utils/date_time_utils.dart';
import 'package:individualprojectfinal/utils/constants.dart';

abstract class ReportCommand {
  void execute();
}

class ReportDataCommand implements ReportCommand {
  final _ReportState state;

  ReportDataCommand(this.state);

  @override
  void execute() {
    state._reportData(state.startDateController.text, state.endDateController.text);
  }
}

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<ReportPage> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  List<String> queriedData = [];
  ReportCommand? _command;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Report Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.spacingAndHeight),
        child: Column(
          children: [
            TextFormField(
              controller: startDateController,
              decoration: const InputDecoration(
                labelText: 'Start Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: Constants.spacingAndHeight),
            TextFormField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'End Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: Constants.spacingAndHeight),
            ElevatedButton(
              onPressed: () {
                handleButtonPress();
              },
              child: const Text('Query Data'),
            ),
            const SizedBox(height: Constants.spacingAndHeight),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Constants.blackColor),
                  borderRadius: BorderRadius.circular(Constants.edgeInset),
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

  void handleButtonPress() {
    setState(() {
      _command = ReportDataCommand(this);
      _executeCommand();
    });
  }

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
    return DateTimeUtils.isValidDateFormat(date);
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateTimeUtils.formatTimestamp(timestamp.toDate());
  }

  String _formatTime(Timestamp timestamp) {
    return DateTimeUtils.formatTime(timestamp);
  }

  void _executeCommand() {
    if (_command != null) {
      _command!.execute();
    }
  }
}
