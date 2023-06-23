import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'notifyPage.dart';

class SensorPage extends StatefulWidget {
  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> with WidgetsBindingObserver {
  List<double>? _userAccelerometerValues;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  bool isDrasticChangeDetected = false;
  Timer? timer;
  bool showDialogBox = false;
  bool isSensorPaused = false;
  bool isSensorEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    if (isSensorEnabled) {
      startSensorSubscriptions();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    timer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isSensorEnabled) {
      startSensorSubscriptions();
    } else {
      stopSensorSubscriptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors Plus Example'),
        elevation: 4,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'UserAccelerometer: $userAccelerometer',
                  style: TextStyle(
                    color: isDrasticChangeDetected ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Accelerometer: $accelerometer',
                  style: TextStyle(
                    color: isDrasticChangeDetected ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Gyroscope: $gyroscope'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Sensor Enabled'),
              Switch(
                value: isSensorEnabled,
                onChanged: (value) {
                  setState(() {
                    isSensorEnabled = value;
                  });
                  if (isSensorEnabled) {
                    startSensorSubscriptions();
                  } else {
                    stopSensorSubscriptions();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void startSensorSubscriptions() {
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          if (!isSensorPaused) {
            setState(() {
              _userAccelerometerValues = <double>[event.x, event.y, event.z];
            });
            checkForDrasticChange(_userAccelerometerValues);
          }
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support Accelerometer Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          if (!isSensorPaused) {
            setState(() {
              _accelerometerValues = <double>[event.x, event.y, event.z];
            });
            checkForDrasticChange(_accelerometerValues);
          }
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support Accelerometer Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                  "It seems that your device doesn't support Gyroscope Sensor",
                ),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );
  }

  void stopSensorSubscriptions() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _streamSubscriptions.clear();
  }

  void checkForDrasticChange(List<double>? values) {
    if (values != null && values.length == 3) {
      // Check for drastic changes in values
      if (values.any((value) => value.abs() > 30)) {
        // Drastic change detected
        setState(() {
          isDrasticChangeDetected = true;
        });
        showDialogBox = true;
        isSensorPaused = true;
        print('Caution: Drastic change detected!');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text('Movement anomalies detected. Are you okay?'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialogBox = false;
                    isSensorPaused = false;
                    timer?.cancel();
                  },
                ),
              ],
            );
          },
        );
        timer = Timer(Duration(seconds: 10), () {
          if (showDialogBox) {
            Navigator.of(context).pop();
            showDialogBox = false;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotifyPage()),
            );
          }
        });
      } else {
        // No drastic change detected
        setState(() {
          isDrasticChangeDetected = false;
        });
      }
    }
  }
}
