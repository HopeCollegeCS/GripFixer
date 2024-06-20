import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
    if (_selectedDevice == null &&
        FlutterBluePlus.adapterState.first == BluetoothAdapterState.on) {
    } else {}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
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
              const SizedBox(width: 10),
              const Text('Grip Strength Tool',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  )),
              // const SizedBox(width: 10),
              // const Icon(
              //   Icons.sports_tennis,
              // ),
              // const SizedBox(width: 10),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'Grip Strength Tool',
            //   style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 20.0),
            // const Icon(
            //   Icons.sports_tennis,
            //   size: 130,
            // ),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child:
                    Text('Select a sensor to connect to, then click Connect'),
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Available sensors'),
              ),
            ),
            // AVAILABLE SENSORS GO HERE
            ...(_discoveredDevices.map((device) => ListTile(
                title: Text(device.platformName),
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
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'Connect',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      if (isConnecting)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push("/WelcomePage");
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                context.push("/Settings");
              },
            ),
          ],
        ),
      ),
    );
  }
}
