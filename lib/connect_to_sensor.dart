import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class ConnectToSensor extends StatefulWidget {
  const ConnectToSensor({super.key});

  @override
  State<ConnectToSensor> createState() => _ConnectToSensor();
}

class _ConnectToSensor extends State<ConnectToSensor> {
  BluetoothDevice? _selectedDevice;
  List<BluetoothDevice> _discoveredDevices = [];

  //initializes the Bluetooth state
  @override
  void initState() {
    super.initState();
    initBluetoothState().then((_) => startScan());
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
      setState(() {
        _discoveredDevices = results.map((result) => result.device).toList();
      });
    }).onDone(() {
      print('Scan finished');
    });
  }

  // when the tile is clicked, this method is called and the device connects
  void connectToDevice(BluetoothDevice device) async {
    try {
      device.connect(timeout: const Duration(seconds: 30), mtu: null).then((s) {
        device.discoverServices(timeout: 30).then((services) {
          // Discover services and characteristics
          //List<BluetoothService> services = await device.discoverServices();
          var service = services
              .where(
                  (s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214"))
              .first;
          var characteristic = service.characteristics
              .where(
                  (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216"))
              .first;
          final subscription = characteristic.onValueReceived.listen((value) {
            // onValueReceived is updated:
            //   - anytime read() is called
            //   - anytime a notification arrives (if subscribed)
            // DIALOG BOX WAS HERE
          });
          // cleanup: cancel subscription when disconnected
          device.cancelWhenDisconnected(subscription);
          // subscribe
          // Note: If a characteristic supports both **notifications** and **indications**,
          // it will default to **notifications**. This matches how CoreBluetooth works on iOS.
          characteristic.setNotifyValue(true);
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
    AppState state = Provider.of<AppState>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Grip Strength Tool',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            const Icon(
              Icons.sports_tennis,
              size: 130,
            ),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child:
                    Text('Select the sensor to connect to then click Connect'),
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
                      state.bluetoothDevice = _selectedDevice;
                      connectToDevice(device);
                    });
                  },
                )))),
            // END OF AVAILABLE SENSORS
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20.0), // Add some spacing
                ElevatedButton(
                  onPressed: () =>
                      context.go("/PlayerSelectPage"), // Call the method
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Make the button square
                    ),
                  ),
                  child: const Text(
                    'Connect',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
