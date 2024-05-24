import 'package:flutter/material.dart';
import 'package:grip_fixer/measure.dart';
import 'package:grip_fixer/player_selection.dart';
import 'package:grip_fixer/sqflite.dart';
import 'welcome_page.dart';
import 'shot_selection.dart';
import 'connect_to_sensor.dart';
import 'package:go_router/go_router.dart';
import 'new_player_page.dart';
import 'recording_screen.dart';
import 'package:provider/provider.dart';
import 'package:grip_fixer/state.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    GoRoute(
      path: "/PlayerSelectPage",
      builder: (context, state) => const PlayerSelection(),
    ),
    GoRoute(
      path: "/NewPlayerPage",
      builder: (context, state) => const NewPlayerPage(),
    ),
    GoRoute(
      path: "/ShotSelectionPage",
      builder: (context, state) => const ShotSelectionPage(),
    ),
    GoRoute(
      path: "/RecordingPage",
      builder: (context, state) => const RecordingScreen(),
    ),
  ],
);

void main() async {
  // database
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  var database = await openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'player_database.db'),
    // When the database is first created, create a table to store players.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE players(firstName STRING PRIMARY KEY, lastName STRING, age STRING, gender STRING, hand STRING)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  var state = AppState();
  var sqlLite = SqfliteClass(database: database);

  runApp(
    //create person object for all user profiles
    ChangeNotifierProvider(
      create: (context) => state,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}
