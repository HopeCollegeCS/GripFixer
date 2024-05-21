import 'package:flutter/material.dart';

// SPACE BETWEEN RADIOLISTTLE's IS TOO BIG

class ShotSelectionPage extends StatefulWidget {
  const ShotSelectionPage({super.key});

  @override
  State<ShotSelectionPage> createState() => ShotSelection();
}

class ShotSelection extends State<ShotSelectionPage> {
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
                'What shot do you want to work on?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10.0), // Add some spacing
          const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                  width: 15,
                  child: Row(children: [
                    Radio(
                      value: 1,
                      groupValue: 1, // Set the initial value
                      onChanged: null, // Disable the radio button for now
                    ),
                    Text('Forehand Groundstroke'),
                  ]),
                ),
                SizedBox(
                  height: 20,
                  width: 15,
                  child: Row(children: [
                    Radio(
                      value: 1,
                      groupValue: 1, // Set the initial value
                      onChanged: null, // Disable the radio button for now
                    ),
                    Text('Backhand Groundstroke'),
                  ]),
                ),
                SizedBox(
                  height: 20,
                  width: 15,
                  child: Row(children: [
                    Radio(
                      value: 1,
                      groupValue: 1, // Set the initial value
                      onChanged: null, // Disable the radio button for now
                    ),
                    Text('Forehand Volley'),
                  ]),
                ),
                SizedBox(
                  height: 20,
                  width: 15,
                  child: Row(children: [
                    Radio(
                      value: 1,
                      groupValue: 1, // Set the initial value
                      onChanged: null, // Disable the radio button for now
                    ),
                    Text('Backhand Volley'),
                  ]),
                ),
                SizedBox(
                  height: 20,
                  width: 15,
                  child: Row(children: [
                    Radio(
                      value: 1,
                      groupValue: 1, // Set the initial value
                      onChanged: null, // Disable the radio button for now
                    ),
                    Text('Serve'),
                  ]),
                ),
                SizedBox(
                  height: 20,
                  width: 15,
                  child: Row(children: [
                    Radio(
                      value: 1,
                      groupValue: 1, // Set the initial value
                      onChanged: null, // Disable the radio button for now
                    ),
                    Text('Other'),
                  ]),
                ),
              ]),
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
                  'Let\'s Hit!',
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
