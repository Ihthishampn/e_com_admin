class UserModel {
  final String id;
  final String name;
  final String number;
  final String imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.number,
    this.imageUrl = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      number:  map['phone'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? name, 
    String? number,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'imageUrl': imageUrl,
    };
  }
}
