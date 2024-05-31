import 'dart:async';
import 'package:grip_fixer/session.dart';
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
          } in playerMaps)
        Person(
            player_id: player_id,
            firstName: firstName,
            lastName: lastName,
            age: age,
            gender: gender,
            hand: hand,
            strength: strength),
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
          } in sessionMaps)
        Session(
          session_id: session_id,
          player_id: player_id,
          session_date: session_date,
          shot_type: shot_type,
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
}
