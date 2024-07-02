import 'dart:async';
import 'package:grip_fixer/grip_target.dart';
import 'package:grip_fixer/session.dart';
import 'package:grip_fixer/session_measurements.dart';
import 'package:sqflite/sqflite.dart';
import 'person.dart';

class SqfliteClass {
  final Database database;
  SqfliteClass({required this.database});

  // Define a function that inserts players into the database
  Future<int> insertPlayer(Person player) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Person into the correct table.
    return await db.insert(
      'players',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertSession(Session session) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Person into the correct table.
    return await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertTarget(Target target) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Person into the correct table.
    return await db.insert(
      'targets',
      target.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertGripStrength(Session session) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Person into the correct table.
    return await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the players from the players table.
  Future<List<Person>> players() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the players.
    final List<Map<String, Object?>> playerMaps = await db.query('players');

    // Convert the list of each player's fields into a list of `Person` objects.
    return [
      for (final {
            'player_id': player_id as int,
            'firstName': firstName as String,
            'lastName': lastName as String,
            'age': age as int,
            'gender': gender as String,
            'hand': hand as String,
            'strength': strength as int,
            'forehandGrip': forehandGrip as String,
          } in playerMaps)
        Person(
          player_id: player_id,
          firstName: firstName,
          lastName: lastName,
          age: age,
          gender: gender,
          hand: hand,
          strength: strength,
          forehandGrip: forehandGrip,
        ),
    ];
  }

  // A method that retrieves all the players from the players table.
  Future<List<Session>> sessions() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the players.
    final List<Map<String, Object?>> sessionMaps = await db.query('sessions');

    // Convert the list of each player's fields into a list of `Person` objects.
    return [
      for (final {
            'session_id': session_id as int,
            'player_id': player_id as int,
            'session_date': session_date as int,
            'shot_type': shot_type as String,
            'violations': violations as List?,
          } in sessionMaps)
        Session(
          session_id: session_id,
          player_id: player_id,
          session_date: session_date,
          shot_type: shot_type,
          violations: violations,
        ),
    ];
  }

  Future<List<Target>> grip_strength_targets() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the players.
    final List<Map<String, Object?>> targetMaps = await db.query('targets');

    // Convert the list of each player's fields into a list of `Person` objects.
    return [
      for (final {
            'stroke': stroke as String,
            'grip_strength': grip_strength as int,
          } in targetMaps)
        Target(
          stroke: stroke,
          grip_strength: grip_strength,
        ),
    ];
  }

  Future<void> updatePlayer(Person player) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Person.
    await db.update(
      'players',
      player.toMap(),
      // Ensure that the Person has a matching id.
      where: 'player_id = ?',
      // Pass the Person's id as a whereArg to prevent SQL injection.
      whereArgs: [player.player_id],
    );
  }

  Future<void> updateSession(Session session) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Person.
    await db.update(
      'sessions',
      session.toMap(),
      // Ensure that the Person has a matching id.
      where: 'session_id = ?',
      // Pass the Person's id as a whereArg to prevent SQL injection.
      whereArgs: [session.session_id],
    );
  }

  Future<int> updateTarget(Target target) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Person.
    return db.update(
      'targets',
      target.toMap(),
      // Ensure that the Person has a matching id.
      where: 'stroke = ?',
      // Pass the Person's id as a whereArg to prevent SQL injection.
      whereArgs: [target.stroke],
    );
  }

  Future<void> deletePlayer(int player_id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Person from the database.
    await db.delete(
      'players',
      // Use a `where` clause to delete a specific player.
      where: 'player_id = ?',
      // Pass the Person's id as a whereArg to prevent SQL injection.
      whereArgs: [player_id],
    );
  }

  // get the sessionMeasurements
  Future<List<SessionMeasurements>> sessionMeasurements() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the players.
    final List<Map<String, Object?>> sessionMeasurementMaps = await db.query('sessionMeasurements');

    // Convert the list of each player's fields into a list of `Person` objects.
    return [
      for (final {
            'session_id': session_id as int,
            'timestamp': timestamp as int,
            'value': value as int,
          } in sessionMeasurementMaps)
        SessionMeasurements(
          session_id: session_id,
          timestamp: timestamp,
          value: value,
        ),
    ];
  }

  Future<int> insertSessionMeasurement(SessionMeasurements sessionMeasurement) async {
    // Get a reference to the database.
    final db = await database;

    bool tableExists = await db
            .rawQuery("SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='session_measurements'")
            .then((value) => Sqflite.firstIntValue(value) ?? 0) >
        0;
    if (!tableExists) {
      await db.execute('''
      CREATE TABLE session_measurements(
        session_id INTEGER PRIMARY KEY, 
        timestamp INTEGER, 
        value INTEGER
      )
    ''');
    }
    // insert the sessionMeasurement into the correct table
    return await db.insert(
      'session_measurements',
      sessionMeasurement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSessionsWithPlayerNames() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT s.*, p.firstName
    FROM sessions s
    INNER JOIN players p ON s.player_id = p.player_id
  ''');

    return result;
  }
}
