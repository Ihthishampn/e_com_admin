import 'dart:developer';

import 'package:e_com_admin/features/categories/data/model/category_model.dart';
import 'package:e_com_admin/features/categories/data/use_case/categories_use_case.dart';
import 'package:e_com_admin/general/utils/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:toastification/toastification.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryProvider with ChangeNotifier {
  final CategoriesUseCase categoriesUseCase;
  CategoryProvider(this.categoriesUseCase);
  AppState addCategoryState = AppState.initial;

  Future<bool> handleAddCategoryWithImage(
      {required String name, required Uint8List imageBytes}) async {
    try {
      addCategoryState = AppState.loading;
      notifyListeners();

      await categoriesUseCase.addCategory(name: name, imageBytes: imageBytes);

      addCategoryState = AppState.success;
      notifyListeners();
      toastification.show(title: const Text('Category added successfully'));
      return true;
    } catch (e) {
      addCategoryState = AppState.error;
      notifyListeners();
      log('error from provider file $e');
      toastification.show(title: Text('Failed to add category: $e'));
      return false;
    }
  }
// fetch
  Stream<List<CategoryModel>> handleCategoryFetch() =>
      categoriesUseCase.getchCategoryModel();
}
