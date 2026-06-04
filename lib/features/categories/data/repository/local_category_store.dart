import 'package:flutter/foundation.dart';
import '../model/category_model.dart';

class LocalCategoryStore {
  LocalCategoryStore._privateConstructor();
  static final LocalCategoryStore instance =
      LocalCategoryStore._privateConstructor();

  final ValueNotifier<List<CategoryModel>> categoriesNotifier = ValueNotifier(
    [],
  );

  List<CategoryModel> get categories => categoriesNotifier.value;

  void addCategory({
    required String name,
    String? parentId,
    String imageUrl = '',
    Uint8List? imageBytes,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final category = CategoryModel(
      id: id,
      name: name,
      parentId: parentId,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      order: categories.length + 1,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    categoriesNotifier.value = [...categoriesNotifier.value, category];
  }

  List<CategoryModel> childrenOf(String parentId) {
    return categories.where((c) => c.parentId == parentId).toList();
  }

  void clear() => categoriesNotifier.value = [];
}
