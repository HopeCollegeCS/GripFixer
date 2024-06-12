import 'package:flutter/material.dart';
import 'package:grip_fixer/person.dart';
import 'package:grip_fixer/session.dart';
import 'package:grip_fixer/session_measurements.dart';
import 'package:grip_fixer/sqflite.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class AppState extends ChangeNotifier {
  late SqfliteClass sqfl;
  Person? person;
  Session? session;
  BluetoothDevice? bluetoothDevice;
  SessionMeasurements? sessionMeasurements;

  AppState({
    this.person,
    this.session,
    this.bluetoothDevice,
    this.sessionMeasurements,
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

  setSessionMeasurements(SessionMeasurements newSessionMeasurements) {
    if (sessionMeasurements == null) {
      sessionMeasurements = newSessionMeasurements;
    } else {
      sessionMeasurements?.setSessionMeasurements(newSessionMeasurements);
    }
  }
}
