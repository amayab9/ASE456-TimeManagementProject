import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RecordTimePage extends StatefulWidget {
  const RecordTimePage({Key? key}) : super(key: key);

  @override
  _RecordTimePageState createState() => _RecordTimePageState();
}

class _RecordTimePageState extends State<RecordTimePage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Record Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: fromTimeController,
              decoration: const InputDecoration(
                labelText: 'From-Time (HH:MM AM/PM)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: toTimeController,
              decoration: const InputDecoration(
                labelText: 'To-Time (HH:MM AM/PM)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Task',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: tagController,
              decoration: const InputDecoration(
                labelText: 'Tag',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveTimeRecord(
                  dateController.text,
                  fromTimeController.text,
                  toTimeController.text,
                  taskController.text,
                  tagController.text,
                );
              },
              child: const Text('Record Time'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTimeRecord(String date, String fromTime, String toTime, String task, String tag) {
    DateTime parsedDate = _parseDate(date);
    TimeOfDay parsedFromTime = _parseTime(fromTime);
    TimeOfDay parsedToTime = _parseTime(toTime);

    DateTime fromDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedFromTime.hour,
      parsedFromTime.minute,
    );

    DateTime toDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedToTime.hour,
      parsedToTime.minute,
    );

    FirebaseFirestore.instance.collection('time_records').add({
      'date': Timestamp.fromDate(parsedDate),
      'fromTime': Timestamp.fromDate(fromDateTime),
      'toTime': Timestamp.fromDate(toDateTime),
      'task': task,
      'tag': tag,
    }).then((value) {
      setState(() {
        //after successfully submitting, clear data
        dateController.clear();
        fromTimeController.clear();
        toTimeController.clear();
        taskController.clear();
        tagController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Record submitted successfully.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit record'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  DateTime _parseDate(String date) {
    if (date.toLowerCase() == 'today') {
      return DateTime.now();
    } else {
      return DateTime.parse(date);
    }
  }

  TimeOfDay _parseTime(String time) {
    List<String> parts = time.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts[1].toLowerCase() == 'pm' && hour < 12) {
      hour += 12;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }
}
