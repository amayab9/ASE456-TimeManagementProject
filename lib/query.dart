import 'dart:js_interop';
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


  void _queryInformation() {
    queriedData.clear();
    if (dropdownValue == 'date' && selectedDate != null) {
      String formattedDate =
          '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';

      FirebaseFirestore.instance
          .collection('time_records')
          .where('date', isEqualTo: formattedDate)
          .get()
          .then(
            (QuerySnapshot querySnapshot) {
              setState(() {
                for (var doc in querySnapshot.docs) {
                  Map<String, dynamic>? data =
                  doc.data() as Map<String, dynamic>?;

                  if (data != null) {
                    queriedData.add(data.toString());
                  }
                }
              });
            },
          )
          .catchError((error) {
            print('Error querying Firestore: $error');
            queriedData.add('Error: $error');
          });
    } else {
      queriedData.add('Invalid input or date not selected');
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        queryController.text =
        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
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
                onChanged: (String? value){
                  setState(() {
                    dropdownValue = value;
                  });
                }
            ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: queryController,
                      decoration: const InputDecoration(
                        labelText: 'Input',
                      ),
                      enabled: dropdownValue != 'date', // Disable manual editing
                    ),
                  ),
                  if (dropdownValue == 'date')
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: (){
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
                      const Text('Queried Data:'),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: queriedData.map((data) => Text(data)).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
