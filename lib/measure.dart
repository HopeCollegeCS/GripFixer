import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_fixer_drawer.dart';
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
  late bool strengthMeasured;

  @override
  void initState() {
    super.initState();
    strength = 0;
    remainingTime = 5;
    isConnectedToBluetooth = false;
    timerStarted = false;
    strengthMeasured = false;
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
          //all 0's exception
          strength = (values.reduce((a, b) => a + b) / values.length).round();
          state.person?.strength = strength;
          var db = state.sqfl;
          db.updatePlayer(state.person!);
          values.clear();
          responseCharacteristic!.setNotifyValue(false);
          strengthMeasured = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
        centerTitle: true,
        leading: IconButton(
          color: (const Color(0xFFFFFFFF)),
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: SizedBox(
          child: Row(
            children: [
              const SizedBox(width: 24),
              const Text('Grip Strength Tool',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  )),
              const SizedBox(width: 45),
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.sports_tennis),
                    color: (const Color(0xFFFFFFFF)),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          if (isConnectedToBluetooth)
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
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
                        backgroundColor: const Color(0xFF5482ab),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
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
                      onPressed: strengthMeasured
                          ? () {
                              print(state.person.toString());
                              context.push("/ShotSelectionPage");
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: strengthMeasured ? const Color(0xFF5482ab) : Colors.grey,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
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
      drawer: const GripFixerDrawer(),
    );
  }
}
