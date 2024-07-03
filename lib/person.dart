// ignore_for_file: non_constant_identifier_names

import 'package:grip_fixer/state.dart';

class Person {
  int? player_id;
  String firstName;
  String? lastName;
  int? age;
  String? gender;
  String? hand;
  int? strength;
  String? forehandGrip;

  Person({
    this.player_id,
    required this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.hand,
    this.strength,
    this.forehandGrip,
  });

  Person setPerson(Person person) {
    player_id = person.player_id;
    firstName = person.firstName;
    lastName = person.lastName;
    age = person.age;
    gender = person.gender;
    hand = person.hand;
    strength = person.strength;
    forehandGrip = person.forehandGrip;
    return this;
  }

  // Convert a Person into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'player_id': player_id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'hand': hand,
      'strength': strength,
      'forehandGrip': forehandGrip,
    };
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Person{player_id: $player_id, firstName: $firstName, lastName: $lastName, age: $age, gender: $gender, hand: $hand, strength: $strength, forehandGrip: $forehandGrip}';
  }

  static void writeToSensorNumberCharacteristic(AppState state) async {
    final sensorNumberCharacteristic = state.sensorNumberCharacteristic;
    int sensorNumber = 0;
    if ((state.person?.hand == 'Right' && state.person?.forehandGrip == 'Continental') ||
        (state.person?.hand == 'Left' && state.person?.forehandGrip == 'Semi-Western')) {
      sensorNumber = 2;
    } else if ((state.person?.hand == 'Right' && state.person?.forehandGrip == 'Semi-Western') ||
        (state.person?.hand == 'Left' && state.person?.forehandGrip == 'Continental')) {
      sensorNumber = 1;
    }
    await sensorNumberCharacteristic!.write([sensorNumber]);
  }
}
