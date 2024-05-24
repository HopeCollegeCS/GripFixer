import 'package:flutter/material.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/sqflite.dart';

class AppState extends ChangeNotifier {
  SqfliteClass? sqfl;
  Person? person;
  String? shot;

  AppState({
    this.sqfl,
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
