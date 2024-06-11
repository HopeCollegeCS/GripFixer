import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePage();
}

String getButtonPath(int value) {
  if (value == 1) {
    return "/RacketSelectPage/PlayerSelectPage";
  } else if (value == 3) {
    return "/RacketSelectPage/MatchingPage";
  } else {
    return "/SelectSession";
  }
}

class _WelcomePage extends State<WelcomePage> {
  int? _selectedValue = 1;
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
          Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align the column to the start
              children: [
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 10.0), // Move the radio button to the left
                      Radio(
                        value: 1, // Assign a value of 1 to this option
                        groupValue:
                            _selectedValue, // Use _selectedValue to track the selected option
                        onChanged: (value) {
                          setState(() {
                            _selectedValue =
                                value!; // Update _selectedValue when option 1 is selected
                          });
                        },
                      ),
                      const Text('Start a hitting session'),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0), // Add some spacing
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 10.0), // Move the radio button to the left
                      Radio(
                        value: 2, // Assign a value of 1 to this option
                        groupValue:
                            _selectedValue, // Use _selectedValue to track the selected option
                        onChanged: (value) {
                          setState(() {
                            _selectedValue =
                                value!; // Update _selectedValue when option 1 is selected
                          });
                        }, // Disable the radio button for now
                      ),
                      const Text('Analyze a previous session'),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0), // Add some spacing
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 10.0), // Move the radio button to the left
                      Radio(
                        value: 3, // Assign a value of 1 to this option
                        groupValue:
                            _selectedValue, // Use _selectedValue to track the selected option
                        onChanged: (value) {
                          setState(() {
                            _selectedValue =
                                value!; // Update _selectedValue when option 1 is selected
                          });
                        }, // Disable the radio button for now
                      ),
                      const Text('Practice hitting target grip tensions'),
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
                onPressed: () => context.go(getButtonPath(_selectedValue!)),
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
