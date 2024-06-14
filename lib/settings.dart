import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_target.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

int forehandGroundstroke = 0;
int forehandVolley = 0;
int overhead = 0;
int serve = 0;
int? id;

Future<int> buttonAction(BuildContext context, String stroke, int strokeValue) {
  var state = Provider.of<AppState>(context, listen: false);

  Target newTarget = Target(
    stroke: stroke,
    grip_strength: strokeValue,
  );

  state.setTarget(newTarget);
  var db = state.sqfl;
  return db.insertTarget(newTarget);
}

class _SettingsPage extends State<SettingsPage> {
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
            'Recommended Grip Strength',
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
            'Forehand groundstroke',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: SizedBox(
              height: 32, // Adjust this value to change the height
              child: TextField(
                onChanged: (text) {
                  forehandGroundstroke = int.tryParse(text)!;
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
      const SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          const SizedBox(width: 28),
          const Text(
            'Forehand volley',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: SizedBox(
              height: 32, // Adjust this value to change the height
              child: TextField(
                onChanged: (text) {
                  forehandVolley = int.tryParse(text)!;
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
      const SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          const SizedBox(width: 28),
          const Text(
            'Overhead',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: SizedBox(
              height: 32, // Adjust this value to change the height
              child: TextField(
                onChanged: (text) {
                  overhead = int.tryParse(text)!;
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
      const SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the left
        children: [
          const SizedBox(width: 28),
          const Text(
            'Serve',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: SizedBox(
              height: 32, // Adjust this value to change the height
              child: TextField(
                onChanged: (text) {
                  serve = int.tryParse(text)!;
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20.0), // Add some spacing
          ElevatedButton(
            onPressed: () {
              //use SQFlite class to insert new player, async so call .then and context.go goes inside

              // buttonAction(
              //     context, "Forehand Groundstroke", forehandGroundstroke);
              // buttonAction(context, "Forehand Volley", forehandVolley);
              // buttonAction(context, "Overhead", overhead);
              buttonAction(context, "Serve", serve).then((newTarget) {
                var appState = Provider.of<AppState>(context, listen: false);

                appState.sqfl.grip_strength_targets().then((targets) {
                  print("Targets: ");
                  for (Target target in targets) {
                    print("Stroke: ${target.stroke}: ${target.grip_strength}");
                  }
                  context.go("/SelectSession");
                });
              });
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
