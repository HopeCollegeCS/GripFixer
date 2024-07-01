import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/grip_fixer_drawer.dart';
import 'package:grip_fixer/grip_target.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

int forehandGroundstroke = 0;
int forehandVolley = 0;
int overhead = 0;
int serve = 0;
String forehandGroundstrokeText = "";
String forehandVolleyText = "";
String overheadText = "";
String serveText = "";
int? id;

Future<int> buttonAction(BuildContext context, String stroke, int strokeValue) {
  var state = Provider.of<AppState>(context, listen: false);

  Target newTarget = Target(
    stroke: stroke,
    grip_strength: strokeValue,
  );

  if (newTarget.stroke == state.target?.stroke) {
    state.setTarget(newTarget);
  }
  state.setTargetMap(stroke, strokeValue);
  //state.setTarget(newTarget);
  var db = state.sqfl;
  return db.updateTarget(newTarget);
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
        leading: IconButton(
          color: const Color(0xFFFFFFFF),
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            const SizedBox(width: 24),
            const Text(
              'Grip Strength Tool',
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
            const Spacer(),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Recommended Grip Strength',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildInputRow('Forehand groundstroke', (text) => forehandGroundstrokeText = text),
                const SizedBox(height: 20),
                _buildInputRow('Forehand volley', (text) => forehandVolleyText = text),
                const SizedBox(height: 20),
                _buildInputRow('Overhead', (text) => overheadText = text),
                const SizedBox(height: 20),
                _buildInputRow('Serve', (text) => serveText = text),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _handleConfirm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5482ab),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const GripFixerDrawer(),
    );
  }

  Widget _buildInputRow(String label, Function(String) onChanged) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 25),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 32,
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.black, width: 5.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              style: const TextStyle(fontSize: 20.0),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      ],
    );
  }

  void _handleConfirm(BuildContext context) {
    forehandGroundstroke = int.tryParse(forehandGroundstrokeText) ?? 0;
    forehandVolley = int.tryParse(forehandVolleyText) ?? 0;
    overhead = int.tryParse(overheadText) ?? 0;
    serve = int.tryParse(serveText) ?? 0;

    buttonAction(context, "Forehand Groundstroke", forehandGroundstroke);
    buttonAction(context, "Forehand Volley", forehandVolley);
    buttonAction(context, "Overhead", overhead);
    buttonAction(context, "Serve", serve).then((newTarget) {
      var appState = Provider.of<AppState>(context, listen: false);

      appState.sqfl.grip_strength_targets().then((targets) {
        print("Targets: ");
        for (Target target in targets) {
          print("Stroke: ${target.stroke}: ${target.grip_strength}");
        }
        var state = Provider.of<AppState>(context, listen: false);
        if (state.target != null) {}
        context.pop();
      });
    });
  }
}
