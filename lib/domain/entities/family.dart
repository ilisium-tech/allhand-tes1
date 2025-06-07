class Family {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final List<String> memberIds;
  final String ownerId;

  Family({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.memberIds,
    required this.ownerId,
  });

  Family copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? memberIds,
    String? ownerId,
  }) {
    return Family(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      memberIds: memberIds ?? this.memberIds,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}