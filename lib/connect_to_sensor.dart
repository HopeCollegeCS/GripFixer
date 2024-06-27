import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:grip_fixer/grip_fixer_drawer.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class ConnectToSensor extends StatefulWidget {
  final String nextRoute;

  const ConnectToSensor(this.nextRoute, {super.key});

  @override
  State<ConnectToSensor> createState() => _ConnectToSensor();
}

class _ConnectToSensor extends State<ConnectToSensor> {
  BluetoothDevice? _selectedDevice;
  List<BluetoothDevice> _discoveredDevices = [];
  AppState state = AppState();
  final Completer<void> completer = Completer();
  bool isConnecting = false;

  //initializes the Bluetooth state
  @override
  void initState() {
    super.initState();
    initBluetoothState().then((_) => startScan());
    state = Provider.of<AppState>(context, listen: false);
  }

  // checks if the Bluetooth adapter is on
  Future<void> initBluetoothState() async {
    bool isOn =
        await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
    if (!isOn) {
      await FlutterBluePlus.turnOn();
    }
    //sets the log level for the flutter_blue_plus package and checks if Bluetooth is supported on the device
    FlutterBluePlus.setLogLevel(LogLevel.debug);
    bool isAvailable = await FlutterBluePlus.isSupported;
    if (!isAvailable) {
      return; //Bluetooth's not available
    }
  }

  // initiates a Bluetooth scan for 5 seconds and updates the state to trigger a rebuild
  void startScan() {
    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
      withServices: <Guid>[Guid("19b10000-e8f2-537e-4f6c-d104768a1214")],
    );

    FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          _discoveredDevices = results.map((result) => result.device).toList();
        });
      }
    }).onDone(() {
      print('Scan finished');
    });
  }

  String screenText() {
    if (state.bluetoothDevice != null) {
      return "You have already connected to a sensor";
    }
    return "Select a sensor, then click Connect";
  }

  // when the tile is clicked, this method is called and the device connects
  // fix FlutterBluePlusException (FlutterBluePlusException | connect | android-code: 133 | ANDROID_SPECIFIC_ERROR)
  // FlutterBluePlusException (FlutterBluePlusException | discoverServices | fbp-code: 6 | Device is disconnected)
  void connectToDevice(BluetoothDevice device) async {
    try {
      isConnecting = true;
      device.connect(timeout: const Duration(seconds: 30), mtu: null).then((s) {
        device.discoverServices(timeout: 30).then((services) {
          // Discover services and characteristics
          //List<BluetoothService> services = await device.discoverServices();
          var service = services
              .where(
                  (s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214"))
              .first;
          var requestCharacteristic = service.characteristics
              .where(
                  (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1215"))
              .first;
          var responseCharacteristic = service.characteristics
              .where(
                  (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216"))
              .first;
          var maxGripStrengthCharacteristic = service.characteristics
              .where(
                  (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1217"))
              .first;
          var targetGripPercentageCharacteristic = service.characteristics
              .where(
                  (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1218"))
              .first;
          var enableFeedbackCharacteristic = service.characteristics
              .where(
                  (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1219"))
              .first;
          var sensorNumberCharacteristic = service.characteristics
              .where(
                  (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1220"))
              .first;
          state.targetGripPercentageCharacteristic =
              targetGripPercentageCharacteristic;
          state.maxGripStrengthCharacteristic = maxGripStrengthCharacteristic;
          state.enableFeedbackCharacteristic = enableFeedbackCharacteristic;
          state.sensorNumberCharacteristic = sensorNumberCharacteristic;
          if (!completer.isCompleted) {
            completer.complete();
          }
          isConnecting = false;
          // final subscription =
          //     responseCharacteristic.onValueReceived.listen((value) {
          //   // onValueReceived is updated:
          //   //   - anytime read() is called
          //   //   - anytime a notification arrives (if subscribed)
          //   // DIALOG BOX WAS HERE

          //   // Save the targetGripPercentageCharacteristic in the AppState

          // });
          // // cleanup: cancel subscription when disconnected
          // device.cancelWhenDisconnected(subscription);
          // subscribe
          // Note: If a characteristic supports both **notifications** and **indications**,
          // it will default to **notifications**. This matches how CoreBluetooth works on iOS.
          responseCharacteristic.setNotifyValue(true);
        });
      });
      setState(() {
        _selectedDevice = device;
      });
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
        centerTitle: true,
        leading: IconButton(
          color: (const Color(0xFFFFFFFF)),
          onPressed: () async {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100.0),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Available sensors:',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(screenText(), style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10.0),
            // AVAILABLE SENSORS GO HERE
            ...(_discoveredDevices.map((device) => ListTile(
                title: Text(device.platformName,
                    style: const TextStyle(fontSize: 16)),
                leading: Radio<BluetoothDevice>(
                  value: device,
                  groupValue: _selectedDevice,
                  onChanged: (value) {
                    setState(() {
                      _selectedDevice = value;
                    });
                  },
                )))),
            // END OF AVAILABLE SENSORS
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment
                        .center, // Center the CircularProgressIndicator
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () async {
                            var state =
                                Provider.of<AppState>(context, listen: false);
                            print(state.target);
                            if (_selectedDevice != null) {
                              state.bluetoothDevice = _selectedDevice;
                              connectToDevice(_selectedDevice!);
                            }
                            if (_selectedDevice == null &&
                                await FlutterBluePlus.adapterState.first ==
                                    BluetoothAdapterState.on) {
                              context.push("/${widget.nextRoute}");
                            }
                            await completer
                                .future; //wait for the characteristic value to be received
                            context.push("/${widget.nextRoute}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5482ab),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'Connect',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      if (isConnecting)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      drawer: const GripFixerDrawer(),
    );
  }
}
