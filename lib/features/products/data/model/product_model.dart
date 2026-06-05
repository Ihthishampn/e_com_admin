import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String productName;
  final String shortNote;
  final String categoryId;
  final List<String> images;
  final List<ProductVariant> variants;
  final List<ProductDetail> details;
  final String additionalNote;
  final double rating;
  final bool isHot;
  final List<String> searchKeywords;
  final DateTime? createdAt;

  ProductModel({
    this.id,
    required this.productName,
    required this.shortNote,
    required this.categoryId,
    this.images = const [],
    this.variants = const [],
    this.details = const [],
    this.additionalNote = '',
    this.rating = 0.0,
    this.isHot = false,
    this.createdAt,
    this.searchKeywords = const [],
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      productName: map['productName'] ?? '',
      shortNote: map['shortNote'] ?? '',
      categoryId: map['categoryId'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      variants: (map['variants'] as List? ?? [])
          .map((v) => ProductVariant.fromMap(Map<String, dynamic>.from(v)))
          .toList(),
      details: (map['details'] as List? ?? [])
          .map((d) => ProductDetail.fromMap(Map<String, dynamic>.from(d)))
          .toList(),
      additionalNote: map['additionalNote'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      isHot: map['isHot'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      searchKeywords: List<String>.from(map['searchKeywords'] ?? []),
    );
  }

  ProductModel copyWith(
      {String? id,
      String? productName,
      String? shortNote,
      String? categoryId,
      List<String>? images,
      List<ProductVariant>? variants,
      List<ProductDetail>? details,
      String? additionalNote,
      double? rating,
      bool? isHot,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<String>? searchKeywords}) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      shortNote: shortNote ?? this.shortNote,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      variants: variants ?? this.variants,
      details: details ?? this.details,
      additionalNote: additionalNote ?? this.additionalNote,
      rating: rating ?? this.rating,
      isHot: isHot ?? this.isHot,
      createdAt: createdAt ?? this.createdAt,
      searchKeywords: searchKeywords ?? this.searchKeywords,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'productName': productName,
      'shortNote': shortNote,
      'categoryId': categoryId,
      'images': images,
      'variants': variants.map((v) => v.toMap()).toList(),
      'details': details.map((d) => d.toMap()).toList(),
      'additionalNote': additionalNote,
      'rating': rating,
      'isHot': isHot,
      "searchKeywords": searchKeywords,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}

class ProductVariant {
  final String unit;
  final String variant;
  final double mrp;
  final double sellingPrice;
  final int stock;

  ProductVariant({
    required this.unit,
    required this.variant,
    required this.mrp,
    required this.sellingPrice,
    required this.stock,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      unit: map['unit'] ?? '',
      variant: map['variant'] ?? '',
      mrp: (map['mrp'] ?? 0).toDouble(),
      sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
      stock: (map['stock'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unit': unit,
      'variant': variant,
      'mrp': mrp,
      'sellingPrice': sellingPrice,
      'stock': stock,
    };
  }
}

class ProductDetail {
  final String heading;
  final String content;

  ProductDetail({required this.heading, required this.content});

  factory ProductDetail.fromMap(Map<String, dynamic> map) {
    return ProductDetail(
      heading: map['heading'] ?? '',
      content: map['content'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'heading': heading, 'content': content};
  }
}
