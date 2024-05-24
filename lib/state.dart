import 'package:flutter/material.dart';
import 'package:grip_fixer/person.dart';

class AppState extends ChangeNotifier {
  Person? person;
  String? shot;

  AppState({
    this.person,
    this.shot,
  });

  setPerson(Person newPerson) {
    if (person == null) {
      person = newPerson;
    } else {
      person?.setPerson(newPerson);
    }
  }

  setShot(String shot) {
    this.shot = shot;
  }
}
