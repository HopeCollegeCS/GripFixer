import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_fixer_drawer.dart';
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
  int? selectedValue = 0;
  List<Session>? sessions = []; // stores the list of sessions
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      var state = Provider.of<AppState>(context);
      var db = state.sqfl;
      db.getSessionsWithPlayerNames().then((sessionList) {
        final sessions = sessionList
            .map((session) => Session(
                  session_id: session['session_id'],
                  player_id: session['player_id'],
                  session_date: session['session_date'],
                  shot_type: session['shot_type'],
                  violations: session['violations'],
                  playerName: session['firstName'],
                ))
            .toList();
        setState(() {
          this.sessions = sessions;
          isLoaded = true;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
        leading: IconButton(
          color: const Color(0xFFFFFFFF),
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Grip Strength Tool', style: TextStyle(color: Color(0xFFFFFFFF))),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.sports_tennis),
                color: const Color(0xFFFFFFFF),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Available Sessions',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  DataTable(
                    columnSpacing: 13,
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Player')),
                      DataColumn(label: Text('Shot')),
                    ],
                    rows: sessions?.map((session) {
                          final formattedDate = session.session_date != null
                              ? DateFormat('MMM d').format(
                                  DateTime.fromMillisecondsSinceEpoch(session.session_date),
                                )
                              : 'N/A';
                          return DataRow(
                            selected: sessions?.indexOf(session) == selectedValue,
                            onSelectChanged: (val) {
                              setState(() {
                                selectedValue = sessions?.indexOf(session);
                              });
                            },
                            cells: [
                              DataCell(Text(formattedDate)),
                              DataCell(Text(session.playerName ?? 'Unknown')),
                              DataCell(Text('${session.shot_type}')),
                            ],
                          );
                        }).toList() ??
                        [],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        context.push("/AnalyzePage");
                        var state = Provider.of<AppState>(context, listen: false);
                        int value = selectedValue!;
                        state.session = sessions?[value];
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5482ab),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'Analyze',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: const GripFixerDrawer(),
    );
  }
}
