import 'package:flutter/material.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});
  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreen();
}

int excess = 0;
int seconds = 0;

Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('AlertDialog Title'),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: <Widget>[
                // Row(
                //   children: [
                //     const Text(
                //         'Show times when recorded tension exceeds target by '),
                //     TextField(),
                //   ],
                // ),
                TextFormField(),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _AnalyzeScreen extends State<AnalyzeScreen> {
  bool light = false;

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
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Show violations only',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Switch(
                  // This bool value toggles the switch.
                  value: light,
                  activeColor: Colors.black,
                  onChanged: (value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      light = value;
                    });
                  },
                ),
                IconButton(
                    onPressed: () {
                      showMyDialog(context);
                    },
                    icon: const Icon(Icons.settings)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print(state.session.toString());
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Make the button square
              ),
            ),
            child: const Text(
              'Start',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ]),
      ),
    );
  }
}
