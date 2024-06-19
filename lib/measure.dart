import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/sqflite.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class MeasureScreen extends StatefulWidget {
  const MeasureScreen({super.key});

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  late int strength;
  late AppState state;
  late int remainingTime;
  Timer? countdownTimer;
  List<int> values = [];
  BluetoothCharacteristic? responseCharacteristic;
  late bool isConnectedToBluetooth;
  late bool timerStarted;

  @override
  void initState() {
    super.initState();
    strength = 0;
    remainingTime = 5;
    isConnectedToBluetooth = false;
    timerStarted = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = Provider.of<AppState>(context);
    BluetoothDevice? device = state.bluetoothDevice;
    if (device != null) {
      subscribeToCharacteristic(device);
    } else {
      print("Bluetooth device is null");
    }
  }

  void subscribeToCharacteristic(BluetoothDevice device) {
    device.discoverServices().then((services) {
      var service = services.where((s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214")).first;
      var requestCharacteristic =
          service.characteristics.where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1215")).first;
      responseCharacteristic =
          service.characteristics.where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216")).first;

      bool averageCalculated = false;

      responseCharacteristic!.onValueReceived.listen((value) {
        if (!averageCalculated) {
          values
              .add(value[0] & 0xFF | ((value[1] & 0xFF) << 8) | ((value[2] & 0xFF) << 16) | ((value[3] & 0xFF) << 24));
        }
      });
      responseCharacteristic!.setNotifyValue(true);
      requestCharacteristic.write([1]);
      setState(() {
        isConnectedToBluetooth = true; // bluetooth connected
      });
    });
  }

  void startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          values.removeWhere((value) => value < 100); // get rid of values less than 100
          strength = (values.reduce((a, b) => a + b) / values.length).round();
          state.person?.strength = strength;
          var db = state.sqfl;
          db.updatePlayer(state.person!);
          values.clear();
          responseCharacteristic!.setNotifyValue(false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    return Scaffold(
      body: Stack(
        children: [
          if (isConnectedToBluetooth)
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Grip Strength Tool",
                        style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Measure ${state.person?.firstName}'s strength",
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "When you click Start, the player should grip the racket with their dominant hand as tightly as possible for a period of 5 seconds.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        timerStarted = true;
                        startCountdownTimer(); // start the countdown timer when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Icon(
                      Icons.access_time_outlined,
                      size: 130,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Strength: $strength',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Remaining Time: $remainingTime seconds',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        print(state.person.toString());
                        context.go("/ShotSelectionPage");
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'Let\'s Hit!',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!isConnectedToBluetooth)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text(
                    'Connecting to Bluetooth...',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
