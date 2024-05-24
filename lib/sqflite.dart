import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'person.dart';

void mainDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
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

  // Define a function that inserts players into the database
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
