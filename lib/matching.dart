import 'package:flutter/material.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreen();
}

const List<String> shots = <String>[
  'Forehand Groundstroke',
  'Backhand Groundstroke',
  'Forehand Volley',
  'Backhand Volley',
  'Serve',
  'Other'
];

//fix formatting
class _MatchingScreen extends State<MatchingScreen> {
  String selectedShot = "Forehand Groundstroke";

  @override
  Widget build(BuildContext context) {
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
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Practice hitting target grip strength",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 28.0),
                const Text(
                  'Shot',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 30.0),
                Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButton<String>(
                    value: selectedShot,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedShot = newValue!;
                      });
                    },
                    // has all the players in the DropDownMenuiTEM
                    items: shots.map((String shot) {
                      return DropdownMenuItem<String>(
                        value: shot,
                        child: Text(shot),
                      );
                    }).toList(),
                    isExpanded: true,
                    underline: const SizedBox(),
                    // end of DropDownButtonItem
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Make the button square
                ),
              ),
              child: const Text(
                'Start',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
