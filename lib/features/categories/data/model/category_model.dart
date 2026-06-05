import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String? id;
  final String name;
  final String imageUrl;
  final DateTime createdAt;
  final List<String> searchKeywords;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    this.searchKeywords = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "createdAt": createdAt.toIso8601String(),
      "searchKeywords": searchKeywords,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json["createdAt"];
    DateTime createdAt;
    if (createdAtValue is String) {
      createdAt = DateTime.parse(createdAtValue);
    } else if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else {
      createdAt = DateTime.now();
    }

    final rawKeywords = json["searchKeywords"];
    final searchKeywords = rawKeywords is List
        ? rawKeywords.map((e) => e.toString()).toList()
        : <String>[];

    return CategoryModel(
      id: json["id"],
      name: json["name"],
      imageUrl: json["imageUrl"],
      createdAt: createdAt,
      searchKeywords: searchKeywords,
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? searchKeywords,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      searchKeywords: searchKeywords ?? this.searchKeywords,
    );
  }
}
