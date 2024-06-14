import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/session_measurements.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  RecordingScreenState createState() => RecordingScreenState();
}

class RecordingScreenState extends State<RecordingScreen> {
  BluetoothCharacteristic? responseCharacteristic;
  AppState state = AppState();
  int? currentResponseValue;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = Provider.of<AppState>(context, listen: false);
    if (state.bluetoothDevice != null) {
      subscribeToCharacteristic(state.bluetoothDevice!);
    } else {
      print('Bluetooth device is null');
    }
  }

  void subscribeToCharacteristic(BluetoothDevice device) {
    device.discoverServices().then((services) {
      var service = services
          .where((s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214"))
          .first;
      var requestCharacteristic = service.characteristics
          .where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1215"))
          .first;
      responseCharacteristic = service.characteristics
          .where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216"))
          .first;

      responseCharacteristic!.onValueReceived.listen((value) {
        int sessionID = state.session?.session_id ?? 0;
        SessionMeasurements sessionMeasurements = SessionMeasurements(
          session_id: sessionID,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          value: value[0] & 0xFF |
              ((value[1] & 0xFF) << 8) |
              ((value[2] & 0xFF) << 16) |
              ((value[3] & 0xFF) << 24),
        );
        //sessionMeasurementsList.add(sessionMeasurements);
        saveToDatabase(state);
      });
      responseCharacteristic!.setNotifyValue(true);
      requestCharacteristic.write([1]);
    });
  }

  SessionMeasurements createSessionMeasurements(int sessionID) {
    return SessionMeasurements(
      session_id: sessionID,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      value: currentResponseValue,
    );
  }

  void saveToDatabase(AppState state) {
    int id = state.session?.session_id ?? 0;
    SessionMeasurements sessionMeasurements = createSessionMeasurements(id);
    state.setSessionMeasurements(sessionMeasurements);
    var db = state.sqfl;
    db.insertSessionMeasurement(sessionMeasurements);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Grip Strength Tool",
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20.0),
          const Icon(
            Icons.sports_tennis,
            size: 130,
          ),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Practicing',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10.0),
                Text('${state.session?.shot_type}',
                    style: const TextStyle(fontSize: 18))
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Target Grip Strength',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10.0),
                Text('${state.person?.strength}',
                    style: const TextStyle(fontSize: 18))
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: const Text(
              "Adjust the camera to ensure players is visible, then start recording.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 6),
          // CAMERA GOES HERE
          ElevatedButton(
            onPressed: () {
              saveToDatabase(state);
              context.go("/VideoRecording"); // just to make it run
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'Done',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ]),
      ),
    );
  }
}
