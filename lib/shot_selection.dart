import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/new_player_page.dart';
import 'package:grip_fixer/grip_target.dart';
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

class ShotSelection extends State<ShotSelectionPage> {
  void writeToTargetGripPercentageCharacteristic(
      AppState state, String shot) async {
    final targetGripPercentageCharacteristic =
        state.targetGripPercentageCharacteristic;
    int shotStrength = state.targetMap[shot]!;
    await targetGripPercentageCharacteristic?.write([
      shotStrength & 0xFF,
      (shotStrength >> 8) & 0xFF,
      (shotStrength >> 16) & 0xFF,
      (shotStrength >> 24) & 0xFF
    ]);
    print('got here to send $shotStrength characteristic');
  }

  void writeToMaxGripStrengthCharacteristic(AppState state) async {
    final maxGripStrengthCharacteristic = state.maxGripStrengthCharacteristic;
    final strength = state.person?.strength;

    if (maxGripStrengthCharacteristic != null && strength != null) {
      await maxGripStrengthCharacteristic.write([
        strength & 0xFF,
        (strength >> 8) & 0xFF,
        (strength >> 16) & 0xFF,
        (strength >> 24) & 0xFF
      ]);
      print('Sent $strength characteristic');
    } else {
      print('Failed to send characteristic');
    }
  }

  void writeToSensorNumberCharacteristic(AppState state) async {
    final sensorNumberCharacteristic = state.sensorNumberCharacteristic;
    int sensorNumber = 0;
    if ((state.person?.hand == 'Right' &&
            state.person?.forehandGrip == 'Continental') ||
        (state.person?.hand == 'Left' &&
            state.person?.forehandGrip == 'Semi-Western')) {
      sensorNumber = 2;
    } else if ((state.person?.hand == 'Right' &&
            state.person?.forehandGrip == 'Semi-Western') ||
        (state.person?.hand == 'Left' &&
            state.person?.forehandGrip == 'Continental')) {
      sensorNumber = 1;
    }
    await sensorNumberCharacteristic!.write([sensorNumber]);
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    //String selectedValue = appState.targetMap.keys.first;

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
              const Text('Grip Strength Tool'),
              const SizedBox(width: 10),
              // const Icon(
              //   Icons.sports_tennis,
              // ),
              const SizedBox(width: 10),
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
                            value: appState.targetMap.keys
                                .toList()
                                .indexOf(target),
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
                      print(appState.person.toString());
                      writeToTargetGripPercentageCharacteristic(appState,
                          appState.targetMap.keys.toList()[selectedValue]);
                      writeToMaxGripStrengthCharacteristic(appState);
                      context.push("/RecordingPage");
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
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    context.push("/PlayerSelectPage");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                context.push("/Settings");
              },
            ),
          ],
        ),
      ),
    );
  }
}
