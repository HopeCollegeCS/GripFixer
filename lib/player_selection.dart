import 'package:flutter/material.dart';

class PlayerSelection extends StatefulWidget {
  const PlayerSelection({super.key});

  @override
  State<PlayerSelection> createState() => _PlayerSelection();
}

//PLACEHOLDER ENUM FOR ACTUAL PLAYERS
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
//END OF PLACEHOLDER

class _PlayerSelection extends State<PlayerSelection> {
  Players? selectedPlayer;

  final List<DropdownMenuItem<Players>> playerItems = Players.values
      .map((Players player) => DropdownMenuItem<Players>(
            value: player,
            child: Text(player.label),
          ))
      .toList();

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
      const SizedBox(height: 20.0),
      const Icon(
        Icons.sports_tennis,
        size: 130,
      ),
      const SizedBox(height: 20.0),
      Row(children: [
        const SizedBox(width: 28.0),
        const Text(
          'Player',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
            width: 30.0), // Add some spacing between the text and dropdown
        //Drop down menu
        Container(
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DropdownButton<Players>(
            value: selectedPlayer,
            onChanged: (Players? newValue) {
              setState(() {
                selectedPlayer = newValue;
              });
            },
            items: playerItems,
            isExpanded: true, // Expand the dropdown to fill the available width
            underline: const SizedBox(), // Remove the underline
          ),
        )
      ]),
      const SizedBox(height: 30.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 125.0), // Add some spacing
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
