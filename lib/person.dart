class Person {
  String? firstName;
  String? lastName;
  String? age;
  String? gender;
  String? hand;

  Person({
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.hand,
  });

  Person setPerson(Person person) {
    firstName = person.firstName;
    lastName = person.lastName;
    age = person.age;
    gender = person.gender;
    hand = person.hand;

    return this;
  }

  // Convert a Person into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'hand': hand,
    };
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Person{firstName: $firstName, lastName: $lastName, age: $age, gender: $gender, hand: $hand}';
  }
}
