import 'package:flutter/material.dart';
import 'package:grip_fixer/measure.dart';
import 'welcome_page.dart';
import 'shot_selection.dart';
import 'connect_to_sensor.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: '/WelcomePage',
  routes: [
    GoRoute(
      path: '/WelcomePage',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: "/ShotSelectionPage",
      builder: (context, state) => const ShotSelectionPage(),
    ),
    GoRoute(
      path: "/MeasurePage",
      builder: (context, state) => const MeasureScreen(),
    ),
    GoRoute(
      path: "/RacketSelectPage",
      builder: (context, state) => const ConnectToSensor(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}
