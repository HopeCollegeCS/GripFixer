// ignore_for_file: non_constant_identifier_names

class Session {
  int? session_id;
  int? player_id;
  int session_date;
  String? shot_type;

  Session({
    this.session_id,
    this.player_id,
    required this.session_date,
    this.shot_type,
  });

  Session setSession(Session session) {
    session_id = session.session_id;
    player_id = session.player_id;
    session_date = session.session_date;
    shot_type = session.shot_type;
    return this;
  }

  // Convert a Person into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'session_id': session_id,
      'player_id': player_id,
      'session_date': session_date,
      'shot_type': shot_type,
    };
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Session{session_id: $session_id, player_id: $player_id, session_date: $session_date, shot_type: $shot_type,}';
  }
}
