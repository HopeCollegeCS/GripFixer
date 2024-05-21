import 'package:flutter/material.dart';
import 'package:grip_fixer/connect_to_sensor.dart';
import 'package:grip_fixer/player_selection.dart';
import 'package:grip_fixer/new_player_page.dart';
import 'welcome_page.dart';
import 'shot_selection.dart';
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
    )
  ],
);

void main() {
  runApp(const MaterialApp(home: WelcomePage()));
}
