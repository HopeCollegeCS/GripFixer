import 'package:flutter/material.dart';

// SPACE BETWEEN RADIOLISTTLE's IS TOO BIG

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
          const SizedBox(height: 10.0), // Add some spacing
          const Column(mainAxisSize: MainAxisSize.min, children: [
            RadioListTile(
              title: Text('Start a hitting session'),
              value: 1,
              groupValue: 1, // Set the initial value
              onChanged: null, // Disable the radio button for now
            ),
            SizedBox(height: 2), // Reduced spacing
            RadioListTile(
              title: Text('Analyze a previous session'),
              value: 2,
              groupValue: 1, // Set the initial value
              onChanged: null, // Disable the radio button for now
            ),
            SizedBox(height: 2), // Reduced spacing
            RadioListTile(
              title: Text('Practice hitting target grip tensions'),
              value: 3,
              groupValue: 1, // Set the initial value
              onChanged: null, // Disable the radio button for now
            ),
          ]),
          const SizedBox(height: 5.0), // Add some spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20.0), // Add some spacing
              ElevatedButton(
                onPressed: () {},
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
