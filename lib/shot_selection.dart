import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

// SPACE BETWEEN RADIOLISTTLE's IS TOO BIG

class ShotSelectionPage extends StatefulWidget {
  const ShotSelectionPage({super.key});

  @override
  State<ShotSelectionPage> createState() => ShotSelection();
}

String _selectedValue = 'Forehand Groundstroke';

void selectShot(BuildContext context) {
  var state = Provider.of<AppState>(context, listen: false);

  state.setShot(_selectedValue);
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
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Forehand Groundstroke',
                  groupValue: _selectedValue, // Set the initial value
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Forehand Groundstroke';
                    });
                  }, // Disable the radio button for now
                ),
                const Text('Forehand Groundstroke'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Backhand Groundstroke',
                  groupValue: _selectedValue, // Set the initial value
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Backhand Groundstroke';
                    });
                  },
                ),
                const Text('Backhand Groundstroke'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Forehand Volley',
                  groupValue: _selectedValue, // Set the initial value
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Forehand Volley';
                    });
                  }, // Disable the radio button for now
                ),
                const Text('Forehand Volley'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Backhand Volley',
                  groupValue: _selectedValue, // Set the initial value
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Backhand Volley';
                    });
                  }, // Disable the radio button for now
                ),
                const Text('Backhand Volley'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Serve',
                  groupValue: _selectedValue, // Set the initial value
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Serve';
                    });
                  }, // Disable the radio button for now
                ),
                const Text('Serve'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Other',
                  groupValue: _selectedValue, // Set the initial value
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Other';
                    });
                  }, // Disable the radio button for now
                ),
                const Text('Other'),
              ]),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20.0), // Add some spacing
              ElevatedButton(
                onPressed: () {
                  context.go("/RecordingPage");
                  selectShot(context);
                },
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
