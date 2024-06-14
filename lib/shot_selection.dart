import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/session.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class ShotSelectionPage extends StatefulWidget {
  const ShotSelectionPage({super.key});

  @override
  State<ShotSelectionPage> createState() => ShotSelection();
}

int? session_id;
int player_id = 0;
int session_date = 1;
String shot_type = "";

int? now = DateTime.now().millisecondsSinceEpoch;

String _selectedValue = shots.keys.first;

const Map<String, int> shots = <String, int>{
  'Forehand Groundstroke': 4,
  'Backhand Groundstroke': 5,
  'Forehand Volley': 6,
  'Backhand Volley': 7,
  'Serve': 8,
  'Other': 0
};

Future<int> buttonAction(BuildContext context) {
  var state = Provider.of<AppState>(context, listen: false);

  player_id = state.person!.player_id!;
  session_date = now!;
  shot_type = _selectedValue;

  Session newSession = Session(
    session_id: session_id,
    player_id: player_id,
    session_date: session_date,
    shot_type: shot_type,
  );

  state.setSession(newSession);
  var db = state.sqfl;
  return db.insertSession(newSession);
}

class ShotSelection extends State<ShotSelectionPage> {
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
                'What shot do you want to work on?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Forehand Groundstroke',
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Forehand Groundstroke';
                    });
                  },
                ),
                const Text('Forehand Groundstroke'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Backhand Groundstroke',
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Backhand Groundstroke';
                    });
                  },
                ),
                const Text('Backhand Groundstroke'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Forehand Volley',
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Forehand Volley';
                    });
                  },
                ),
                const Text('Forehand Volley'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Backhand Volley',
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Backhand Volley';
                    });
                  },
                ),
                const Text('Backhand Volley'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Serve',
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Serve';
                    });
                  },
                ),
                const Text('Serve'),
              ]),
            ),
            SizedBox(
              height: 20,
              width: 15,
              child: Row(children: [
                Radio(
                  value: 'Other',
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = 'Other';
                    });
                  },
                ),
                const Text('Other'),
              ]),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20.0),
              ElevatedButton(
                onPressed: () {
                  //use SQFlite class to insert new player, async so call .then and context.go goes inside
                  buttonAction(context).then((newSessionId) {
                    var appState =
                        Provider.of<AppState>(context, listen: false);
                    appState.session?.session_id = newSessionId;
                    print(appState.person.toString());
                    context.go("/RecordingPage");
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'Let\'s Hit!',
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
