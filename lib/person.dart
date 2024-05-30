// ignore_for_file: non_constant_identifier_names

//Add a field called strength which will hold the grip strength of the player. Changes every time

class Person {
  int? player_id;
  String firstName;
  String? lastName;
  int? age;
  String? gender;
  String? hand;
  int? strength;

  Person({
    this.player_id,
    required this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.hand,
    this.strength,
  });

  Person setPerson(Person person) {
    player_id = person.player_id;
    firstName = person.firstName;
    lastName = person.lastName;
    age = person.age;
    gender = person.gender;
    hand = person.hand;
    strength = person.strength;
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
    };
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Person{player_id: $player_id, firstName: $firstName, lastName: $lastName, age: $age, gender: $gender, hand: $hand, strength: $strength}';
  }
}
