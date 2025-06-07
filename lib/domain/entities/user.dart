class User {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final DateTime birthDate;
  final String phoneNumber;
  final List<String> familyIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.birthDate,
    required this.phoneNumber,
    required this.familyIds,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? birthDate,
    String? phoneNumber,
    List<String>? familyIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      familyIds: familyIds ?? this.familyIds,
    );
  }
}