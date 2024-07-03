import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_fixer_drawer.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class SensorReadScreen extends StatefulWidget {
  const SensorReadScreen({super.key});

  @override
  State<SensorReadScreen> createState() => SensorReadScreenState();
}

class SensorReadScreenState extends State<SensorReadScreen> {
  late AppState state;
  String selectedShot = "";
  Person? selectedPlayer;
  bool playersLoaded = false;
  List<Person> playersList = [];
  List<int> values = [];
  late Queue<int> strengthQueue = Queue<int>();
  late bool isConnectedToBluetooth;
  BluetoothCharacteristic? responseCharacteristic;
  late double currentValue;
  late bool isStarted;
  late bool isPaused;

  @override
  void initState() {
    super.initState();
    isConnectedToBluetooth = false;
    isStarted = false;
    isPaused = false;
    currentValue = 0;
    strengthQueue.add(0);
    if (playersList.isNotEmpty) {
      selectedPlayer = playersList.first;
    }
  }

  void subscribeToCharacteristic(BluetoothDevice device) {
    late int receivedValue;
    device.discoverServices().then((services) {
      var service = services.where((s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214")).first;
      var requestCharacteristic =
          service.characteristics.where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1215")).first;
      responseCharacteristic =
          service.characteristics.where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216")).first;

      responseCharacteristic!.onValueReceived.listen((value) {
        if (!isStarted) {
          receivedValue =
              (value[0] & 0xFF | ((value[1] & 0xFF) << 8) | ((value[2] & 0xFF) << 16) | ((value[3] & 0xFF) << 24));
          if (!isPaused && mounted) {
            setState(() {
              isConnectedToBluetooth = true; // bluetooth connected
              currentValue = receivedValue.toDouble();
            });
          }
        }
      });
      responseCharacteristic!.setNotifyValue(true);
      requestCharacteristic.write([1]);
      responseCharacteristic!.setNotifyValue(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    int calculatedIncomingStrength = currentValue.toInt();
    strengthQueue.add(calculatedIncomingStrength);
    setState(() {
      values = strengthQueue.toList();
    });

    state = Provider.of<AppState>(context);
    Map<String, int>? shots = state.targetMap.cast<String, int>();
    //get the player list
    if (!playersLoaded) {
      // getting the state
      var state = Provider.of<AppState>(context);
      // getting the database from the state
      var db = state.sqfl;
      // getting the list from the database
      db.players().then((playerList) {
        setState(() {
          playersList = playerList;
          playersLoaded = true;
        });
      });
    }
    // did change dependencies?
    BluetoothDevice? device = state.bluetoothDevice;
    if (device != null) {
      subscribeToCharacteristic(device);
    } else {
      print("Bluetooth device is null");
    }
    // now time to build;
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
      body: Stack(children: [
        if (isConnectedToBluetooth)
          Center(
            child: Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
              child: Column(children: [
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Test sensor functionality",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Resting values ranging from 0-15 is normal. However, squeezing the racket should result in values in the hundreds.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  const Text(
                    'Incoming Strength:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$calculatedIncomingStrength',
                    style: const TextStyle(fontSize: 20),
                  ),
                ]),
                const SizedBox(height: 30),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5482ab),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isPaused = !isPaused;
                        });
                      },
                      child: Text(
                        isPaused ? 'Resume' : 'Pause',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ]),
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
      ]),
      drawer: const GripFixerDrawer(),
    );
  }
}
