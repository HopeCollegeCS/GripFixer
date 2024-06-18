import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_target.dart';
import 'package:grip_fixer/session.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class TargetShotSelectionPage extends StatefulWidget {
  const TargetShotSelectionPage({super.key});

  @override
  State<TargetShotSelectionPage> createState() => TargetShotSelection();
}

int? session_id;
int player_id = 0;
int session_date = 1;
String shot_type = "";
int selectedValue = 0;
int? now = DateTime.now().millisecondsSinceEpoch;
//String _selectedValue = ;

// const Map<String, int> shots = <String, int>{
//   'Forehand Groundstroke': 4,
//   'Backhand Groundstroke': 5,
//   'Forehand Volley': 6,
//   'Backhand Volley': 7,
//   'Serve': 8,
//   'Other': 0
// };

Future<int> buttonAction(BuildContext context, String gripTarget) {
  var state = Provider.of<AppState>(context, listen: false);

  player_id = state.person!.player_id!;
  session_date = now!;
  shot_type = gripTarget;

  Session newSession = Session(
    session_id: session_id,
    player_id: player_id,
    session_date: session_date,
    shot_type: shot_type,
  );

  state.setSession(newSession);
  var db = state.sqfl;
  Target newTarget = Target(
    stroke: gripTarget,
    grip_strength: state.targetMap[gripTarget],
  );
  state.setTarget(newTarget);
  return db.insertSession(newSession);
}

class TargetShotSelection extends State<TargetShotSelectionPage> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    //String selectedValue = appState.targetMap.keys.first;

    return Scaffold(
        body: SingleChildScrollView(
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
          SizedBox(
            child: DataTable(
              columnSpacing: 13,
              columns: const [
                DataColumn(label: SizedBox(width: 20)),
                DataColumn(label: Text('Shots')),
              ],
              //border: TableBorder.all(),
              //rows: appState.targetMap.keys.toList() ?? [],
              rows: appState.targetMap.keys.toList().map((target) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 3,
                        child: Radio(
                          value:
                              appState.targetMap.keys.toList().indexOf(target),
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    DataCell(Text('$target')),
                  ],
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20.0),
              ElevatedButton(
                onPressed: () {
                  //use SQFlite class to insert new player, async so call .then and context.go goes inside
                  buttonAction(context,
                          appState.targetMap.keys.toList()[selectedValue])
                      .then((newSessionId) {
                    appState.session?.session_id = newSessionId;
                    context.go("/MatchingPage");
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