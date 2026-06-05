import 'dart:typed_data';

import 'package:e_com_admin/features/categories/data/model/category_model.dart';
import 'package:e_com_admin/features/categories/domain/repo/categories_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CategoriesUseCase {
  final CategoriesRepo repo;
  CategoriesUseCase(this.repo);

  Future<void> addCategory(
      {required String name, required Uint8List imageBytes}) async {
    return await repo.addCategory(name: name, imageBytes: imageBytes);
  }

  Stream<List<CategoryModel>> getchCategoryModel() {
    return repo.getCategory();
  }
}
