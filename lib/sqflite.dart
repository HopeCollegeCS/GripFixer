import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'person.dart';

class SqfliteClass {
  final Database database;
  SqfliteClass({required this.database});

  // Define a function that ins<erts players into the database
  Future<void> insertPlayer(Person player) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Person into the correct table.
    await db.insert(
      'players',
      player.toMap(),
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
            'firstName': firstName as String,
            'lastName': lastName as String,
            'age': age as String,
            'gender': gender as String,
            'hand': hand as String,
          } in playerMaps)
        Person(
            firstName: firstName,
            lastName: lastName,
            age: age,
            gender: gender,
            hand: hand),
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
      where: 'firstName = ?',
      // Pass the Person's id as a whereArg to prevent SQL injection.
      whereArgs: [player.firstName],
    );
  }

  Future<void> deletePlayer(String firstName) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Person from the database.
    await db.delete(
      'players',
      // Use a `where` clause to delete a specific player.
      where: 'firstName = ?',
      // Pass the Person's id as a whereArg to prevent SQL injection.
      whereArgs: [firstName],
    );
  }
}
