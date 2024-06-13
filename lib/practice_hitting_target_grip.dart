import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/state.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreen();
}

const List<String> shots = <String>[
  'Forehand Groundstroke',
  'Backhand Groundstroke',
  'Forehand Volley',
  'Backhand Volley',
  'Serve',
  'Other'
];

class _MatchingScreen extends State<MatchingScreen> {
  late AppState state;
  String selectedShot = "Forehand Groundstroke";
  Person? selectedPlayer;
  bool playersLoaded = false;
  List<Person> playersList = [];
  List<int> values = [];
  late bool isConnectedToBluetooth;
  BluetoothCharacteristic? responseCharacteristic;
  late double currentValue;
  late bool isStarted;

  @override
  void initState() {
    super.initState();
    isConnectedToBluetooth = false;
    isStarted = false;
    currentValue = 0;
    if (playersList.isNotEmpty) {
      selectedPlayer = playersList.first;
    }
    selectedShot = shots.first;
  }

  void subscribeToCharacteristic(BluetoothDevice device) {
    late int receivedValue;
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
        if (!isStarted) {
          receivedValue = (value[0] & 0xFF |
              ((value[1] & 0xFF) << 8) |
              ((value[2] & 0xFF) << 16) |
              ((value[3] & 0xFF) << 24));
          setState(() {
            isConnectedToBluetooth = true; // bluetooth connected
            currentValue = receivedValue.toDouble();
          });
        }
      });
      responseCharacteristic!.setNotifyValue(true);
      requestCharacteristic.write([1]);
      responseCharacteristic!.setNotifyValue(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AppState>(context);
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
        body: Stack(children: [
      if (isConnectedToBluetooth)
        Center(
          child: Container(
            margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
            child: Column(children: [
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Grip Strength Tool",
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Practice hitting target grip strength",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Player',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10.0),
                  Container(
                    width: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: DropdownButton<Person>(
                      value: selectedPlayer,
                      onChanged: (Person? newValue) {
                        setState(() {
                          selectedPlayer = newValue;
                        });
                      },
                      items: playersList.map((Person player) {
                        return DropdownMenuItem<Person>(
                          value: player,
                          child: Text(player.firstName),
                        );
                      }).toList(),
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Shot',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 29.0),
                  Container(
                    width: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: DropdownButton<String>(
                      value: selectedShot,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedShot = newValue!;
                        });
                      },
                      items: shots.map((String shot) {
                        return DropdownMenuItem<String>(
                          value: shot,
                          child: Text(shot),
                        );
                      }).toList(),
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text(
                  'Max Strength:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                if (selectedPlayer != null)
                  Text(
                    '${selectedPlayer!.strength}',
                    style: const TextStyle(fontSize: 20),
                  ),
              ]),
              Row(children: [
                const Text(
                  'Incoming Strength:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 2),
                if (selectedPlayer != null)
                  Text(
                    '$currentValue',
                    style: const TextStyle(fontSize: 20),
                  ),
              ]),
              const SizedBox(height: 20),
              /*ElevatedButton(
                onPressed: () {
                  isStarted = true;
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Make the button square
                  ),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),*/
              const SizedBox(height: 20),
              SfLinearGauge(
                minimum: 0,
                maximum: selectedPlayer != null && selectedPlayer!.strength != 0
                    ? selectedPlayer!.strength!.toDouble()
                    : 10,
                markerPointers: [
                  LinearShapePointer(
                    value: selectedPlayer != null &&
                            selectedPlayer!.strength != 0
                        ? ((min(currentValue,
                                        selectedPlayer!.strength!.toDouble())) /
                                    selectedPlayer!.strength!.toDouble()) *
                                (selectedPlayer!.strength!.toDouble() - 1) +
                            1
                        : 0,
                  ),
                ],
                barPointers: [
                  LinearBarPointer(
                    value: selectedPlayer != null &&
                            selectedPlayer!.strength != 0
                        ? ((min(currentValue,
                                        selectedPlayer!.strength!.toDouble())) /
                                    selectedPlayer!.strength!.toDouble()) *
                                (selectedPlayer!.strength!.toDouble() - 1) +
                            1
                        : 0,
                  )
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
    ]));
  }
}
