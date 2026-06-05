import 'dart:typed_data';
import 'package:e_com_admin/features/categories/data/model/category_model.dart';

abstract class CategoriesRepo {
  // create
  Future<void> addCategory(
      {required String name, required Uint8List imageBytes});
  // get
  Stream<List<CategoryModel>> getCategory();
  //edit
  Future<void> editCategory(
      {required String uid, required CategoryModel editCategoryData});
  // delete
  Future<void> deleteCategory({required String id});
}
