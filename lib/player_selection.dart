import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class PlayerSelection extends StatefulWidget {
  const PlayerSelection({super.key});

  @override
  State<PlayerSelection> createState() => _PlayerSelection();
}

class _PlayerSelection extends State<PlayerSelection> {
  Person? selectedPlayer;
  List<Person> newPlayersList = [];
  bool playersLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (!playersLoaded) {
      // getting the state
      var state = Provider.of<AppState>(context);
      // getting the database from the state
      var db = state.sqfl;
      // // getting the list from the database
      // final playerList = db?.players();
      // ???
      db.players().then((playerList) {
        /// works
        final newPlayersList = [
          // ... (the spread operator) to create a new list that includes all the elements from playerList and New Player... at the end
          ...playerList,
          //Person(firstName: 'Chris'),
          Person(firstName: 'New Player')
        ];
        setState(() {
          this.newPlayersList = newPlayersList;
          playersLoaded = true;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(),
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
            Row(
              children: [
                const SizedBox(width: 28.0),
                const Text(
                  'Player',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 30.0),
                Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButton<Person>(
                    value: selectedPlayer,
                    onChanged: (Person? newValue) {
                      setState(() {
                        selectedPlayer = newValue;
                      });
                    },
                    // has all the players in the DropDownMenuiTEM
                    items: newPlayersList.map((player) {
                      return DropdownMenuItem<Person>(
                        value: player,
                        child: Text(player.firstName),
                      );
                    }).toList(),
                    isExpanded: true,
                    underline: const SizedBox(),
                    // end of DropDownButtonItem
                  ),
                )
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 125.0),
                // stays the same
                ElevatedButton(
                  onPressed: selectedPlayer == null
                      ? null
                      : selectedPlayer?.firstName == 'New Player'
                          ? () {
                              context.go("/NewPlayerPage");
                            }
                          : () {
                              context.go("/ShotSelectionPage");
                              var state =
                                  Provider.of<AppState>(context, listen: false);
                              state.person = selectedPlayer;
                            },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Get Started',
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
                context.go("/Settings");
              },
            ),
          ],
        ),
      ),
    );
  }
}
