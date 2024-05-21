import 'package:flutter/material.dart';

class PlayerSelection extends StatefulWidget {
  const PlayerSelection({super.key});

  @override
  State<PlayerSelection> createState() => _PlayerSelection();
}

enum Players {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  const Players(this.label, this.color);
  final String label;
  final Color color;
}

class _PlayerSelection extends State<PlayerSelection> {
  String? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text(
        'Grip Strength Tool',
        style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 20.0),
      const Icon(
        Icons.sports_tennis,
        size: 130,
      ),
      const SizedBox(height: 20.0),
      const Row(children: [
        SizedBox(width: 28.0),
        Text(
          'Player',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 30.0), // Add some spacing between the text and dropdown
        //DROP DOWN BOX
      ]),
      const SizedBox(height: 30.0),
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          )
        ],
      ),
    ])));
  }
}
