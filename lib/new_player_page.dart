import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/gripFixerDrawer.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class NewPlayerPage extends StatefulWidget {
  const NewPlayerPage({super.key});

  @override
  State<NewPlayerPage> createState() => _NewPlayer();
}

int? player_id;
String firstName = "";
String lastName = "";
int age = 0;
String placeholderAge = "";
String gender = "";
String hand = "";
int strength = 0;
String forehandGrip = "";

Future<int> buttonAction(BuildContext context) {
  var state = Provider.of<AppState>(context, listen: false);

  Person newPerson = Person(
    player_id: player_id,
    firstName: firstName,
    lastName: lastName,
    age: age,
    gender: gender,
    hand: hand,
    strength: strength,
    forehandGrip: forehandGrip,
  );

  state.setPerson(newPerson);
  var db = state.sqfl;
  return db.insertPlayer(newPerson);
}

class _NewPlayer extends State<NewPlayerPage> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 30.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 28),
                Text('Add a new Player', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 28),
                const Text(
                  'First Name',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: SizedBox(
                    height: 32,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 28),
                const Text(
                  'Last Name',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(width: 19),
                Expanded(
                  child: SizedBox(
                    height: 32,
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 32),
                const Text(
                  'Age',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(width: 93),
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: TextField(
                      onChanged: (text) {
                        //age = int.tryParse(text)!;
                        placeholderAge = text;
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
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(width: 28),
              const Text(
                'Gender',
                style: TextStyle(fontSize: 25),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 45.0),
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const SizedBox(width: 59.0),
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
            Center(
                child: Row(
              children: [
                Radio(
                  value: 'Eastern',
                  groupValue: forehandGrip,
                  onChanged: (value) {
                    setState(() {
                      forehandGrip = 'Eastern';
                    });
                  },
                ),
                const Text('Eastern'),
                const SizedBox(width: 8.0),
                Radio(
                  value: 'Semi-Western',
                  groupValue: forehandGrip,
                  onChanged: (value) {
                    setState(() {
                      forehandGrip = 'Semi-Western';
                    });
                  },
                ),
                const Text('Semi-Western'),
                const SizedBox(width: 8.0),
                Radio(
                  value: 'Continental',
                  groupValue: forehandGrip,
                  onChanged: (value) {
                    setState(() {
                      forehandGrip = 'Continental';
                    });
                  },
                ),
                const Text('Continental'),
              ],
            )),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20.0), // Add some spacing
                ElevatedButton(
                  onPressed: () {
                    age = int.tryParse(placeholderAge)!;
                    //use SQFlite class to insert new player, async so call .then and context.go goes inside
                    buttonAction(context).then((newPlayerId) {
                      var appState = Provider.of<AppState>(context, listen: false);
                      appState.person?.player_id = newPlayerId;
                      context.push("/MeasurePage");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5482ab),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Measure Grip Strength',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ),
          ])),
      drawer: const GripFixerDrawer(),
    );
  }
}
