import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewPlayerPage extends StatefulWidget {
  const NewPlayerPage({super.key});

  @override
  State<NewPlayerPage> createState() => _NewPlayer();
}

class _NewPlayer extends State<NewPlayerPage> {
  String firstName = "";
  String lastName = "";
  String age = "";
  String gender = "";
  String hand = "";

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
      const Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          SizedBox(width: 28),
          Text(
            'Add a new Player',
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
      const SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          const SizedBox(width: 28),
          const Text(
            'First Name',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: SizedBox(
              height: 32, // Adjust this value to change the height
              child: TextField(
                onChanged: (text) {
                  firstName = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          const SizedBox(width: 28),
          const Text(
            'Last Name',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: SizedBox(
              height: 32, // Adjust this value to change the height
              child: TextField(
                onChanged: (text) {
                  lastName = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          const SizedBox(width: 28),
          const Text(
            'Age',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: SizedBox(
              height: 32, // Adjust this value to change the height
              child: TextField(
                onChanged: (text) {
                  age = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    ])));
  }
}
