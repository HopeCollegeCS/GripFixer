import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class MeasureScreen extends StatelessWidget {
  const MeasureScreen({super.key});

//fix formatting

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    String strength;
    //var db = state.sqfl;
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
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Measure ${state.person?.firstName}'s strength",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "When you click Start, the player should grip the racket with their dominant hand as tightly as possible for a period of 5 seconds.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            //text box
            TextField(
              onChanged: (text) {
                strength = text;
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
            ElevatedButton(
              onPressed: () {
                context.go("/ShotSelectionPage");
                //set the strength part of person equal to strength in here
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Make the button square
                ),
              ),
              child: const Text(
                'Let\'s Hit!',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16.0),
            const Icon(
              Icons.timer,
              size: 130,
            ),
          ]),
        ),
      ),
    );
  }
}
