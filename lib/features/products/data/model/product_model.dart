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
  final List<String> keywords;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int taxPercentageAmount;
  final bool isTrustedProduct;

  ProductModel({
    this.id,
    required this.productName,
    required this.shortNote,
    required this.categoryId,
    this.images = const [],
    this.variants = const [],
    this.details = const [],
    this.additionalNote = '',
    this.keywords = const [],
    this.createdAt,
    this.updatedAt,
    this.taxPercentageAmount = 0,
    this.isTrustedProduct = false,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      productName: map['productName'] ?? '',
      shortNote: map['shortNote'] ?? '',
      categoryId: map['categoryId'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      variants: _parseVariants(map['variants']),
      details: (map['details'] as List? ?? [])
          .map((d) => ProductDetail.fromMap(d))
          .toList(),
      additionalNote: map['additionalNote'] ?? '',
      keywords: List<String>.from(map['keywords'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      taxPercentageAmount: (map['taxPercentageAmount'] ?? 0).toInt(),
      isTrustedProduct: map['isTrustedProduct'] ?? false,
    );
  }

  static List<ProductVariant> _parseVariants(dynamic variantsData) {
    if (variantsData is List) {
      return variantsData.map((v) => ProductVariant.fromMap(v)).toList();
    } else if (variantsData is Map) {
      return variantsData.values.map((v) => ProductVariant.fromMap(v)).toList();
    }
    return [];
  }

  ProductModel copyWith({
    String? id,
    String? productName,
    String? shortNote,
    String? categoryId,
    List<String>? images,
    List<ProductVariant>? variants,
    List<ProductDetail>? details,
    String? additionalNote,
    List<String>? keywords,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? taxPercentageAmount,
    bool? isTrustedProduct,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      shortNote: shortNote ?? this.shortNote,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      variants: variants ?? this.variants,
      details: details ?? this.details,
      additionalNote: additionalNote ?? this.additionalNote,
      keywords: keywords ?? this.keywords,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      taxPercentageAmount: taxPercentageAmount ?? this.taxPercentageAmount,
      isTrustedProduct: isTrustedProduct ?? this.isTrustedProduct,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'productName': productName,
      'shortNote': shortNote,
      'categoryId': categoryId,
      'images': images,
      'variants': {
        for (var v in variants)
          (v.uid ??
                  DateTime.now().millisecondsSinceEpoch.toString() +
                      (v.unit.hashCode + v.variant.hashCode).abs().toString()):
              v.toMap()
      },
      'details': details.map((d) => d.toMap()).toList(),
      'additionalNote': additionalNote,
      'keywords': keywords,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
      'taxPercentageAmount': taxPercentageAmount,
      'isTrustedProduct': isTrustedProduct,
    };
  }
}

class ProductVariant {
  final String? uid;
  final String unit;
  final String variant;
  final double mrp;
  final double sellingPrice;
  final int stock;
  final String giftBox;

  ProductVariant({
    this.uid,
    required this.unit,
    required this.variant,
    required this.mrp,
    required this.sellingPrice,
    required this.stock,
    this.giftBox = '',
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      uid: map['uid'],
      unit: map['unit'] ?? '',
      variant: map['variant'] ?? '',
      mrp: (map['mrp'] ?? 0).toDouble(),
      sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
      stock: (map['stock'] ?? 0).toInt(),
      giftBox: map['giftBox'] ?? '',
    );
  }

  get price => null;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid ??
          DateTime.now().millisecondsSinceEpoch.toString() +
              (unit.hashCode + variant.hashCode).abs().toString(),
      'unit': unit,
      'variant': variant,
      'mrp': mrp,
      'sellingPrice': sellingPrice,
      'stock': stock,
      'giftBox': giftBox,
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
    return {
      'heading': heading,
      'content': content,
    };
  }
}