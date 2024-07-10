import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_fixer_drawer.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreen();
}

class _MatchingScreen extends State<MatchingScreen> {
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

  void writeToSensorNumberCharacteristic(AppState state) async {
    final sensorNumberCharacteristic = state.sensorNumberCharacteristic;
    int sensorNumber = 0;
    if ((state.person?.hand == 'Right' && state.person?.forehandGrip == 'Continental') ||
        (state.person?.hand == 'Left' && state.person?.forehandGrip == 'Semi-Western')) {
      sensorNumber = 1;
    } else if ((state.person?.hand == 'Right' && state.person?.forehandGrip == 'Semi-Western') ||
        (state.person?.hand == 'Left' && state.person?.forehandGrip == 'Continental')) {
      sensorNumber = 2;
    }
    await sensorNumberCharacteristic!.write(
        [sensorNumber & 0xFF, (sensorNumber >> 8) & 0xFF, (sensorNumber >> 16) & 0xFF, (sensorNumber >> 24) & 0xFF]);
    print(sensorNumber);
  }

  @override
  Widget build(BuildContext context) {
    int calculatedIncomingStrength = selectedPlayer != null && selectedPlayer!.strength != 0
        ? (((min(currentValue, selectedPlayer!.strength!.toDouble())) / selectedPlayer!.strength!.toDouble()) *
                    (10 - 1) +
                1)
            .round()
        : 0;
    strengthQueue.add(calculatedIncomingStrength);
    if (strengthQueue.length > 10) {
      strengthQueue.removeFirst();
    }
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
                          state.person = newValue;
                          writeToSensorNumberCharacteristic(state);
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
                        value: selectedShot.isNotEmpty ? selectedShot : null,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedShot = newValue!;
                          });
                        },
                        items: shots.keys.map((String shot) {
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
                    'Incoming Strength:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  if (selectedPlayer != null)
                    Text(
                      '$calculatedIncomingStrength',
                      style: const TextStyle(fontSize: 20),
                    ),
                ]),
                const SizedBox(height: 30),
                SfLinearGauge(
                  minimum: 0,
                  maximum: 10,
                  markerPointers: [
                    LinearShapePointer(value: shots[selectedShot]?.toDouble() ?? 0.0),
                  ],
                  barPointers: [
                    LinearBarPointer(
                      value: calculatedIncomingStrength.toDouble(),
                      color: linearBarColor(
                        calculatedIncomingStrength.toDouble(),
                        shots[selectedShot]?.toDouble() ?? 0.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SfCartesianChart(
                    primaryXAxis: const NumericAxis(
                      minimum: 0,
                      maximum: 10,
                      interval: 1,
                    ),
                    primaryYAxis: const NumericAxis(
                      minimum: 0,
                      maximum: 10,
                      interval: 1,
                    ),
                    series: <LineSeries<int, int>>[
                      LineSeries<int, int>(
                        dataSource: values,
                        xValueMapper: (int value, int index) => index,
                        yValueMapper: (int value, int index) => value,
                        animationDuration: 200,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isPaused = !isPaused;
                        });
                      },
                      child: Text(isPaused ? 'Resume' : 'Pause'),
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

  Color linearBarColor(double barValue, double targetValue) {
    final difference = (barValue - targetValue).abs();
    if (difference == 0) {
      return Colors.green;
    } else if (difference == 1) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
