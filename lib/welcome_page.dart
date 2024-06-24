import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/gripFixerDrawer.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePage();
}

String getButtonPath(int value) {
  if (value == 1) {
    return "/RacketSelectPage/PlayerSelectPage";
  } else if (value == 3) {
    return "/RacketSelectPage/MatchingPage";
  } else {
    return "/SelectSession";
  }
}

class _WelcomePage extends State<WelcomePage> {
  int? _selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
        leading: const SizedBox(),
        centerTitle: true,
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
                    icon: const Icon(
                      Icons.sports_tennis,
                    ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 140),
            const Row(
              children: [
                SizedBox(width: 20.0),
                Text(
                  'What do you want to do?',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const SizedBox(width: 10.0),
                      Radio(
                        value: 1,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      const Text(
                        'Start a hitting session',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14.0),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const SizedBox(width: 10.0),
                      Radio(
                        value: 2,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      const Text(
                        'Analyze a previous session',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14.0),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const SizedBox(width: 10.0),
                      Radio(
                        value: 3,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Practice hitting target grip tensions',
                          style: TextStyle(fontSize: 22),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 54.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 26.0),
                ElevatedButton(
                  onPressed: () {
                    context.push(getButtonPath(_selectedValue!));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5482ab),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
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
