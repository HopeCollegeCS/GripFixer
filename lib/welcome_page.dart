import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
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
          const Row(
            children: [
              SizedBox(width: 20.0),
              Text(
                'What do you want to do?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16.0), // Add some spacing
          const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align the column to the start
              children: [
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 10.0), // Move the radio button to the left
                      Radio(
                        value: 0,
                        groupValue: 0, // Set the initial value
                        onChanged: null, // Disable the radio button for now
                      ),
                      Text('Start a hitting session'),
                    ],
                  ),
                ),
                SizedBox(height: 5.0), // Add some spacing
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 10.0), // Move the radio button to the left
                      Radio(
                        value: 0,
                        groupValue: 0, // Set the initial value
                        onChanged: null, // Disable the radio button for now
                      ),
                      Text('Analyze a previous session'),
                    ],
                  ),
                ),
                SizedBox(height: 5.0), // Add some spacing
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 10.0), // Move the radio button to the left
                      Radio(
                        value: 0,
                        groupValue: 0, // Set the initial value
                        onChanged: null, // Disable the radio button for now
                      ),
                      Text('Practice hitting target grip tensions'),
                    ],
                  ),
                ),
              ]),
          const SizedBox(height: 16.0), // Add some spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20.0), // Add some spacing
              ElevatedButton(
                onPressed: () => context.go("/ShotSelectionPage"),
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Make the button square
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
