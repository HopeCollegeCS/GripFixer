import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';
import 'package:grip_fixer/session.dart';
import 'package:intl/intl.dart';

class SelectSession extends StatefulWidget {
  const SelectSession({super.key});

  @override
  State<SelectSession> createState() => _SelectSession();
}

class _SelectSession extends State<SelectSession> {
  int? selectedValue = 1;
  List<Session>? sessions = []; // stores the list of sessions
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      // getting the state
      var state = Provider.of<AppState>(context);
      // getting the database from the state
      var db = state.sqfl;
      // // getting the list from the database

      db.sessions().then((sessionList) {
        final sessions = [
          // ... (the spread operator) to create a new list that includes all the elements from playerList and New Player... at the end
          ...sessionList,
        ];
        setState(() {
          this.sessions = sessions;
          isLoaded = true;
        });
      });
    }

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Text(
                  'Available Sessions',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 16.0),
              ],
            ),

            //start on video stuff
            SizedBox(
              child: DataTable(
                columnSpacing: 13,
                columns: const [
                  DataColumn(label: SizedBox(width: 20)),
                  DataColumn(label: Text('Session Date')),
                  DataColumn(label: Text('Player')),
                  DataColumn(label: Text('Shot')),
                ],
                border: TableBorder.all(),
                rows: sessions?.map((session) {
                      final formattedDate = session.session_date != null
                          ? DateFormat('MMM d').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  session.session_date),
                            )
                          : 'N/A';
                      return DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 3,
                              child: Radio(
                                value: sessions?.indexOf(session),
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue =
                                        selectedValue == value ? null : value;
                                  });
                                },
                              ),
                            ),
                          ),
                          DataCell(Text(formattedDate)),
                          DataCell(Text('${session.player_id}')),
                          DataCell(Text('${session.shot_type}')),
                        ],
                      );
                    }).toList() ??
                    [],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.go("/AnalyzePage"),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Analyze',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
