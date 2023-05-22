class AppUser {
  final String? uid;
  final String name;

  AppUser({
    this.uid,
    required this.name,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      AppUserFields.uid: uid,
      AppUserFields.name: name,
    };
  }

  static AppUser fromJSON(Map<String, dynamic> json) {
    return AppUser(
      uid: json[AppUserFields.uid] as String?,
      name: json[AppUserFields.name] as String,
    );
  }

  AppUser copyWith({
    String? uid,
    String? name,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'AppUser(uid: $uid, name: $name)';
}

class AppUserFields {
  static String uid = 'uid';
  static String name = 'name';
}
