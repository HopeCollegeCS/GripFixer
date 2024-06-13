// ignore_for_file: non_constant_identifier_names

class Target {
  int? id;
  String? stroke;
  int? grip_strength;

  Target({
    this.id,
    this.stroke,
    this.grip_strength,
  });

  Target setTarget(Target target) {
    id = target.id;
    stroke = target.stroke;
    grip_strength = target.grip_strength;

    return this;
  }

  // Convert a Person into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'stroke': stroke,
      'grip_strength': grip_strength,
    };
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Session{id: $id, stroke: $stroke, grip_strength: $grip_strength,}';
  }
}
