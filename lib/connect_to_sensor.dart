import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//PLACEHOLDER ENUM FOR AVAILABLE SENSORS
enum AvailableSensors { sensor1, sensor2, sensor3 }

class ConnectToSensor extends StatefulWidget {
  const ConnectToSensor({super.key});

  @override
  State<ConnectToSensor> createState() => _ConnectToSensor();
}

class _ConnectToSensor extends State<ConnectToSensor> {
  AvailableSensors? _selectedSensor;

  @override
  Widget build(BuildContext context) {
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
            ...AvailableSensors.values.map((sensor) => ListTile(
                title: Text(sensor.toString()),
                leading: Radio<AvailableSensors>(
                  value: sensor,
                  groupValue: _selectedSensor,
                  onChanged: (value) {
                    setState(() {
                      _selectedSensor = value;
                    });
                  },
                ))),
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
