import 'package:flutter/material.dart';
import 'package:grip_fixer/analyze.dart';
import 'package:grip_fixer/matching.dart';
import 'package:grip_fixer/measure.dart';
import 'package:grip_fixer/player_selection.dart';
import 'package:grip_fixer/select_session.dart';
import 'package:grip_fixer/sqflite.dart';
import 'package:grip_fixer/video_recording.dart';
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
    GoRoute(
      path: "/MatchingPage",
      builder: (context, state) => const MatchingScreen(),
    ),
    GoRoute(
      path: "/AnalyzePage",
      builder: (context, state) => const AnalyzeScreen(),
    ),
    GoRoute(
      path: "/SelectSession",
      builder: (context, state) => const SelectSession(),
    ),
    GoRoute(
      path: "/VideoRecording",
      builder: (context, state) => const VideoRecorderScreen(),
    ),
    // GoRoute(
    //   path: "/VideoPlaying",
    //   builder: (context, state) => const VideoPlayerScreen(
    //     videoPath: '',
    //   ),
    // ),
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
    onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      var batch = db.batch();
      //add grip strength field
      batch.execute(
        'CREATE TABLE players(player_id INTEGER PRIMARY KEY AUTOINCREMENT, firstName STRING, lastName STRING, age INTEGER, gender STRING, hand STRING, strength INTEGER, forehandGrip STRING)',
      );
      //Session ID incrementing is not relative to player (so you can't have 2 session 1s). Problem?
      batch.execute(
        'CREATE TABLE sessions(session_id INTEGER PRIMARY KEY AUTOINCREMENT, player_id INTEGER, session_date INTEGER, shot_type STRING)',
      );
      await batch.commit();
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  var state = AppState();
  var sqlLite = SqfliteClass(database: database);
  state.sqfl = sqlLite;

  // deleteDatabase(join(await getDatabasesPath(), 'player_database.db'));
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
