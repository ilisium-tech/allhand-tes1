import '../../domain/entities/family.dart';

class FamilyModel extends Family {
  FamilyModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.createdAt,
    required super.memberIds,
    required super.ownerId,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      memberIds: List<String>.from(json['memberIds'] ?? []),
      ownerId: json['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'memberIds': memberIds,
      'ownerId': ownerId,
    };
  }

  factory FamilyModel.fromEntity(Family family) {
    return FamilyModel(
      id: family.id,
      name: family.name,
      description: family.description,
      imageUrl: family.imageUrl,
      createdAt: family.createdAt,
      memberIds: family.memberIds,
      ownerId: family.ownerId,
    );
  }
}