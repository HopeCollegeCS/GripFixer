import 'package:flutter/material.dart';

class MeasureScreen extends StatelessWidget {
  const MeasureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Grip Strength Tool",
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Measure Grip Strength",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "When you click Start, the player should grip the racket with their dominant hand as tightly as possible for a period of 5 seconds.",
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Start'),
          ),
          const SizedBox(height: 16.0),
          const Icon(
            Icons.timer,
            size: 130,
          ),
        ]),
      ),
    );
  }
}
