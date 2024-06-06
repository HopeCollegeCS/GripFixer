import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    strength = 0;
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
      var service = services
          .where((s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214"))
          .first;
      var requestCharacteristic = service.characteristics
          .where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1215"))
          .first;
      var responseCharacteristic = service.characteristics
          .where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216"))
          .first;
      responseCharacteristic.onValueReceived.listen((value) {
        setState(() {
          strength = value[0];
        });
      });
      responseCharacteristic.setNotifyValue(true);
      requestCharacteristic.write([1]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
          child: Column(children: [
            const Align(
              alignment: Alignment.topLeft,
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
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Measure ${state.person?.firstName}'s strength",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "When you click Start, the player should grip the racket with their dominant hand as tightly as possible for a period of 5 seconds.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'Start',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            // DISPLAY THE STRENGTH
            Text(
              'Strength: $strength',
              style: const TextStyle(fontSize: 18),
            ),
            // END OF STRENGTH DISPLAY
            TextField(
              onChanged: (text) {
                strength = int.tryParse(text)!;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.black, width: 5.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              style: const TextStyle(fontSize: 20.0),
            ),
            ElevatedButton(
              onPressed: () {
                context.go("/ShotSelectionPage");
                state.person?.strength = strength;
                //set the strength part of person equal to strength in here
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'Let\'s Hit!',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16.0),
            const Icon(
              Icons.timer,
              size: 130,
            ),
          ]),
        ),
      ),
    );
  }
}
