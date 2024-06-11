import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/session_measurements.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  RecordingScreenState createState() => RecordingScreenState();
}

class RecordingScreenState extends State<RecordingScreen> {
  Timer? timer;

  SessionMeasurements createSessionMeasurements(int sessionID) {
    return SessionMeasurements(
      session_id: sessionID,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      value: null,
    );
  }

  void startRecording(AppState state) {
    int counter = 0;
    int id = state.session?.session_id ?? 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter < 60) {
        SessionMeasurements sessionMeasurements = createSessionMeasurements(id);
        // save the sessionMeasurements somehwere
        counter++;
      } else {
        timer.cancel();
        if (mounted) {
          context.go("/VideoRecording");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Align(
            alignment: Alignment.center,
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
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Practicing',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10.0),
                Text('${state.session?.shot_type}',
                    style: const TextStyle(fontSize: 18))
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Target Grip Strength',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10.0),
                Text('${state.person?.strength}',
                    style: const TextStyle(fontSize: 18))
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: const Text(
              "Adjust the camera to ensure players is visible, then start recording.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 6),
          // CAMERA GOES HERE
          ElevatedButton(
            onPressed: () {
              startRecording(state);
              context.go("/VideoRecording"); // just to make it run
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'Done',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ]),
      ),
    );
  }
}
