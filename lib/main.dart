import 'package:flutter/material.dart';
import 'package:grip_fixer/analyze.dart';
import 'package:grip_fixer/grip_target.dart';
import 'package:grip_fixer/practice_hitting_target_grip.dart';
import 'package:grip_fixer/measure.dart';
import 'package:grip_fixer/player_selection.dart';
import 'package:grip_fixer/select_for_target_practice.dart';
import 'package:grip_fixer/select_session.dart';
import 'package:grip_fixer/sensor_read.dart';
import 'package:grip_fixer/settings.dart';
import 'package:grip_fixer/sqflite.dart';
import 'package:grip_fixer/video_recording.dart';
import 'welcome_page.dart';
import 'shot_selection.dart';
import 'connect_to_sensor.dart';
import 'package:go_router/go_router.dart';
import 'new_player_page.dart';
import 'record_practice_session.dart';
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
      path: "/RacketSelectPage/:nextRoute",
      builder: (context, state) => ConnectToSensor(state.pathParameters['nextRoute']!),
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
    GoRoute(
      path: "/Settings",
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: "/TargetGripSelect",
      builder: (context, state) => const TargetShotSelectionPage(),
    ),
    GoRoute(
      path: "/SensorRead",
      builder: (context, state) => const SensorReadScreen(),
    ),
  ],
);

void createAndFillTargetsTable(var batch) {
  batch.execute(
    'CREATE TABLE targets(stroke STRING PRIMARY KEY, grip_strength INTEGER)',
  );
  batch.execute(
    'insert into targets values ("Forehand Groundstroke", 5)',
  );
  batch.execute(
    'insert into targets values ("Forehand Volley", 5)',
  );
  batch.execute(
    'insert into targets values ("Overhead", 5)',
  );
  batch.execute(
    'insert into targets values ("Serve", 5)',
  );
}

void main() async {
  // database
  WidgetsFlutterBinding.ensureInitialized();

  // deleteDatabase(join(await getDatabasesPath(), 'player_database.db'));

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
        'CREATE TABLE sessions(session_id INTEGER PRIMARY KEY AUTOINCREMENT, player_id INTEGER, session_date INTEGER, shot_type STRING, violations LIST)',
      );

      batch.execute(
        'CREATE TABLE session_measurements(session_id INTEGER PRIMARY KEY, timestamp INTEGER, value INTEGER)',
      );
      createAndFillTargetsTable(batch);
      await batch.commit();
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      var batch = db.batch();
      for (int version = oldVersion + 1; version <= newVersion; version++) {
        switch (version) {
          case 2:
            createAndFillTargetsTable(batch);
            break;
        }
      }
      await batch.commit();
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 2,
  );

  var state = AppState();
  var sqlLite = SqfliteClass(database: database);
  state.sqfl = sqlLite;
  sqlLite.grip_strength_targets().then((targets) {
    for (Target target in targets) {
      state.setTargetMap(target.stroke, target.grip_strength);
    }
  });
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
