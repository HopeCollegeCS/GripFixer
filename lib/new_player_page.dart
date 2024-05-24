import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class NewPlayerPage extends StatefulWidget {
  const NewPlayerPage({super.key});

  @override
  State<NewPlayerPage> createState() => _NewPlayer();
}

String firstName = "";
String lastName = "";
String age = "";
String gender = "";
String hand = "";

void buttonAction(BuildContext context) {
  var state = Provider.of<AppState>(context, listen: false);

  Person newPerson = Person(
      firstName: firstName,
      lastName: lastName,
      age: age,
      gender: gender,
      hand: hand);

  state.setPerson(newPerson);
}

class _NewPlayer extends State<NewPlayerPage> {
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
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          const SizedBox(width: 28),
          const Text(
            'Last Name',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 19),
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
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          const SizedBox(width: 32),
          const Text(
            'Age',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 93),
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
      SizedBox(height: 10),
      Row(
          mainAxisAlignment: MainAxisAlignment.start, // Align to the left
          children: [
            SizedBox(width: 28),
            const Text(
              'Gender',
              style: TextStyle(fontSize: 25),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                        width: 45.0), // Move the radio button to the left
                    Radio(
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = 'Male';
                        });
                      },
                    ),
                    const Text('Male'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                        width: 59.0), // Move the radio button to the left
                    Radio(
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = 'Female';
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
              ],
            )
          ]),
      const SizedBox(height: 8),
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
            value: 'Left',
            groupValue: hand,
            onChanged: (value) {
              setState(() {
                hand = 'Left';
              });
            },
          ),
          const Text('Left Handed'),
          const SizedBox(width: 20.0),
          Radio(
            value: 'Right',
            groupValue: hand,
            onChanged: (value) {
              setState(() {
                hand = 'Right';
              });
            },
          ),
          const Text('Right Handed'),
        ],
      )),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20.0), // Add some spacing
          ElevatedButton(
            onPressed: () {
              context.go("/MeasurePage");
              buttonAction(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Make the button square
              ),
            ),
            child: const Text(
              'Measure Grip Strength',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          )
        ],
      ),
    ])));
  }
}
