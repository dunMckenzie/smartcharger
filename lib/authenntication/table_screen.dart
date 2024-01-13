import 'dart:async';
import 'package:charger/pages/usage_gauge.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('usage');
  String _currentDate = '';
  String timeData = '';
  String usageData = '';

  List<UsageData> usageDataList = [];

  final StreamController<double> _usageStreamController =
      StreamController<double>();

  @override
  void initState() {
    super.initState();
    _getCurrentDate();
    _getCurrentTime();
    _listenToUsage();
    _loadData();
  }


  @override
  void dispose() {
    _usageStreamController.close();
    super.dispose();
  }

  void _getCurrentDate(){
    var now = DateTime.now();
    _currentDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _getCurrentTime() {
    var now = DateTime.now();
    timeData =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

  }
  void _listenToUsage() {
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          usageData = event.snapshot.value.toString();
          _getCurrentDate();
          _getCurrentTime();
          usageDataList.add(
            UsageData(date: _currentDate, time: timeData, usage: usageData)
          );
          _saveTableRow();

          _usageStreamController.add(double.parse(usageData));
        });
      }
    }
    );
  }

  void _loadData() {
    if (usageDataList.isEmpty) {
      _loadTableRows();
      if (usageDataList.isEmpty) {
        int oneMonthInMillis = 30 * 24 * 60 * 60 * 1000;
        int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;

        _databaseReference.onChildAdded.listen((dynamic event) {
          if (event.snapshot.value != null) {
            Map<String, dynamic> data =
            Map<String, dynamic>.from(event.snapshot.value);
            DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(data['timestamp']);

            if (currentTimeInMillis - dateTime.millisecondsSinceEpoch <=
                oneMonthInMillis) {
              setState(() {
                _currentDate =
                '${dateTime.year}-${dateTime.month}-${dateTime.day}';
                timeData =
                '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
                usageData = data['usage'].toString();
                usageDataList.add(
                  UsageData(
                    date: _currentDate,
                    time: timeData,
                    usage: usageData,
                  ),
                );
              });
            }
          }
        });
      }
    }
  }


  Future<void> _saveTableRow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedRows = prefs.getStringList('tableRows') ?? [];
    savedRows.add('$_currentDate, $timeData, $usageData');
    await prefs.setStringList('tableRows', savedRows);
}

Future<void> _clearTable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('tableRows');
    setState(() {
      usageDataList.clear();
    });
}
Future<List<TableRow>> _loadTableRows() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedRows = prefs.getStringList('tableRows') ?? [];
    List<TableRow> newTableRows = [];
    for (String row in savedRows) {
      List<String> rowData = row.split(',');
      newTableRows.add(
        TableRow(children: [
          TableCell(child: Text(rowData[0])),
          TableCell(child: Text(rowData[1])),
          TableCell(child: Text(rowData[2])),
        ]),
      );
    }

    return newTableRows;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging History'),
        backgroundColor: Colors.cyanAccent,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Clear Data'),
                      content:
                      const Text('Are you sure you want to clear data?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: _clearTable,
                          child: const Text('Yes'),
                        )
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.delete,
            ),
            color: Colors.red,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _loadTableRows(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TableRow>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(),
                  children: [
                    const TableRow(children: [
                      TableCell(child: Text(' Date')),
                      TableCell(child: Text(' Time')),
                      TableCell(child: Text(' Charge')),
                    ]),
                    ...snapshot.data!,
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsageGaugePage(
                usageDataStream: _usageStreamController.stream,
              ),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.show_chart),
      ),

    );

  }
}

class UsageData {
  final String date;
  final String time;
  final String usage;

  UsageData({required this.date, required this.time, required this.usage});
}