import 'package:flutter/material.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/session.dart';
import 'package:grip_fixer/sqflite.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class AppState extends ChangeNotifier {
  late SqfliteClass sqfl;
  Person? person;
  Session? session;
  BluetoothDevice? bluetoothDevice;

  AppState({
    this.person,
    this.session,
    this.bluetoothDevice,
  });

  setPerson(Person newPerson) {
    if (person == null) {
      person = newPerson;
    } else {
      person?.setPerson(newPerson);
    }
  }

  setSession(Session newSession) {
    if (session == null) {
      session = newSession;
    } else {
      session?.setSession(newSession);
    }
  }
}
