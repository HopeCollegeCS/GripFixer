class SessionMeasurements {
  int? session_id;
  int? timestamp;
  int? value;

  SessionMeasurements({
    this.session_id,
    this.timestamp,
    this.value,
  });

  SessionMeasurements setSessionMeasurements(
      SessionMeasurements sessionMeasurements) {
    session_id = sessionMeasurements.session_id;
    timestamp = sessionMeasurements.timestamp;
    value = sessionMeasurements.value;
    return this;
  }

  // Convert a SessionMeasurement into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'session_id': session_id,
      'timestamp': timestamp,
      'value': value,
    };
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'SessionMeasurements{session_id: $session_id, timestap: $timestamp, value: $value}';
  }
}
