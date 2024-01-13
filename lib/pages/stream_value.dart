import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StreamData extends StatefulWidget {
  const StreamData({super.key});

  @override
  State<StreamData> createState() => _StreamDataState();
}

class _StreamDataState extends State<StreamData> {
  String usage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DatabaseReference databaseReference =
    // ignore: deprecated_member_use
    FirebaseDatabase.instance.reference().child('usage');
    databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      setState(() {
        usage = snapshot.value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            usage,
            style: const TextStyle(fontSize: 24),
          )
        ],
      ),
    );
  }
}