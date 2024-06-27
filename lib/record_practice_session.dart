import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_fixer_drawer.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  RecordingScreenState createState() => RecordingScreenState();
}

class RecordingScreenState extends State<RecordingScreen> {
  BluetoothCharacteristic? responseCharacteristic;
  AppState state = AppState();
  int? currentResponseValue;
  Timer? timer;
  bool enableFeedback = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
        centerTitle: true,
        leading: IconButton(
          color: (const Color(0xFFFFFFFF)),
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: SizedBox(
          child: Row(
            children: [
              const SizedBox(width: 24),
              const Text('Grip Strength Tool',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  )),
              const SizedBox(width: 45),
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.sports_tennis),
                    color: (const Color(0xFFFFFFFF)),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 100),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Target Grip Strength:',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10.0),
                Text('${state.target?.grip_strength}',
                    style: const TextStyle(fontSize: 24))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 15),
              const Text('Enable Feedback ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Switch(
                  value: enableFeedback,
                  onChanged: (value) {
                    setState(() {
                      enableFeedback = value;
                    });
                  })
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Practicing: ',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.session?.shot_type}',
                        style: const TextStyle(fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: const Text(
              "Adjust the camera to ensure players is visible, then start recording.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 10),
          // CAMERA GOES HERE
          ElevatedButton(
            onPressed: () async {
              final enableFeedbackCharacteristic =
                  state.enableFeedbackCharacteristic;
              await enableFeedbackCharacteristic
                  ?.write([enableFeedback ? 1 : 0]); // 1 for true, 0 for false
              state.enableFeedback = enableFeedback;
              print('enable feedback $enableFeedback');
              context.push("/VideoRecording");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5482ab),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
            ),
          ),
        ]),
      ),
      drawer: const GripFixerDrawer(),
    );
  }
}
