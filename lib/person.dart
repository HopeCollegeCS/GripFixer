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
}
