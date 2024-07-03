import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_fixer_drawer.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
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
                  DataColumn(label: Text('Shots')),
                ],
                rows: appState.targetMap.keys.toList().map((target) {
                  return DataRow(
                    selected: appState.targetMap.keys.toList().indexOf(target) == selectedValue,
                    onSelectChanged: (val) {
                      setState(() {
                        selectedValue = appState.targetMap.keys.toList().indexOf(target);
                      });
                    },
                    cells: [
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
                    buttonAction(context, appState.targetMap.keys.toList()[selectedValue]).then((newSessionId) {
                      appState.session?.session_id = newSessionId;
                      context.push("/MatchingPage");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Let\'s Hit!',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      drawer: const GripFixerDrawer(),
    );
  }
}
