import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';

class UsageGaugePage extends StatefulWidget {
  const UsageGaugePage({Key? key, required Stream<double> usageDataStream})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UsageGaugePageState createState() => _UsageGaugePageState();
}

class _UsageGaugePageState extends State<UsageGaugePage> {
  final StreamController<double> _streamController = StreamController<double>();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _onNewValue(double value) {
    _streamController.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: GaugeChart(usageDataStream: _streamController.stream)),
          StreamData(onNewValue: _onNewValue),
        ],
      ),
    );
  }
}

class GaugeChart extends StatefulWidget {
  final Stream<double> usageDataStream;

  const GaugeChart({super.key, required this.usageDataStream});

  @override
  State<GaugeChart> createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart> {
  double _usageValue = 0;

  @override
  void initState() {
    super.initState();
    widget.usageDataStream.listen((value) {
      setState(() {
        _usageValue = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usage Gauge Chart'),
      ),
      body: Center(
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                interval: 10,
                showLabels: true,
                showTicks: true,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    color: Colors.green,
                  ),
                  GaugeRange(
                    startValue: 30,
                    endValue: 70,
                    color: Colors.yellow,
                  ),
                  GaugeRange(
                    startValue: 70,
                    endValue: 100,
                    color: Colors.green,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: _usageValue,
                    enableAnimation: true,
                    animationDuration: 1000,
                    needleColor: Colors.blueGrey,
                    tailStyle: const TailStyle(color: Colors.blueAccent),
                    needleLength: 0.6,
                    knobStyle: const KnobStyle(knobRadius: 0.1, color: Colors.blue),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(_usageValue.toStringAsFixed(2),
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                    positionFactor: 0.5,
                    angle: 90,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class StreamData extends StatefulWidget {
  final Function(double) onNewValue;

  const StreamData({super.key, required this.onNewValue});

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

      double usageValue = double.parse(snapshot.value.toString());
      widget.onNewValue(usageValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}