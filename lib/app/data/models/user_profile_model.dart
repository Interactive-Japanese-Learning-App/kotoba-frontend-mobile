class UserProfile {
  final String id;
  final String email;
  final int xp;
  final int level;

  UserProfile({
    required this.id,
    required this.email,
    required this.xp,
    required this.level,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["_id"] ?? "",
      email: json["email"] ?? "",
      xp: json["xp"] ?? 0,
      level: json["level"] ?? 1,
    );
  }
}