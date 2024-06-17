import 'package:flutter/material.dart';
import 'package:grip_fixer/grip_target.dart';
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
  Target? target;
  SessionMeasurements? sessionMeasurements;
  BluetoothCharacteristic? targetGripPercentageCharacteristic;

  AppState({
    this.person,
    this.session,
    this.bluetoothDevice,
    this.target,
    this.sessionMeasurements,
    this.targetGripPercentageCharacteristic,
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

  setTarget(Target newTarget) {
    if (target == null) {
      target = newTarget;
    } else {
      target?.setTarget(newTarget);
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
