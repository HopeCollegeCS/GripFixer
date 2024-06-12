// ignore_for_file: non_constant_identifier_names

import 'dart:collection';

class Target {
  int? id;
  LinkedHashMap? strokes;

  Target({
    this.id,
    this.strokes,
  });

  Target setTarget(Target target) {
    id = target.id;
    strokes = target.strokes;
    return this;
  }

  // Convert a Person into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'strokes': strokes,
    };
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Session{id: $id, stroke: $strokes,}';
  }
}
