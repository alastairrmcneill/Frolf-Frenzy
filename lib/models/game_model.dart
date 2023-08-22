class Game {
  String? uid;
  String? hostUid;
  Game({
    this.uid,
    this.hostUid,
  });

  Game copyWith({
    String? uid,
    String? hostUid,
  }) {
    return Game(
      uid: uid ?? this.uid,
      hostUid: hostUid ?? this.hostUid,
    );
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      GameFields.uid: uid,
      GameFields.hostUid: hostUid,
    };
  }

  static Game fromJSON(json) {
    return Game(
      uid: json[GameFields.uid] != null ? json[GameFields.uid] as String : null,
      hostUid: json[GameFields.hostUid] != null ? json[GameFields.hostUid] as String : null,
    );
  }

  @override
  String toString() => 'Game(uid: $uid, hostUid: $hostUid)';

  @override
  bool operator ==(covariant Game other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.hostUid == hostUid;
  }
}

class GameFields {
  static String uid = 'uid';
  static String hostUid = 'hostUid';
}
