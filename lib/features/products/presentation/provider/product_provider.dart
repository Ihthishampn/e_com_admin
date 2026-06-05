import 'dart:typed_data';

import 'package:e_com_admin/features/products/data/use_case/product_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';

@injectable
class ProductProvider extends ChangeNotifier {
  final ProductsUseCase productsUseCase;

  bool isLoading = false;

  ProductProvider(this.productsUseCase);

  Stream<List<ProductModel>> handleProductFetch() {
    return productsUseCase.fetchProducts();
  }

  Stream<List<ProductModel>> handleProductsByCategory(String categoryId) {
    return productsUseCase.fetchProductsByCategory(categoryId);
  }

  Future<bool> handleAddProductWithImages({
    required ProductModel product,
    required List<Uint8List> imageBytes,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await productsUseCase.addProductWithImages(
        product: product,
        imageBytes: imageBytes,
      );

      toastification.show(
        title: const Text('Success'),
        description: const Text('Product added successfully'),
        backgroundColor: Colors.green,
      );
      return true;
    } catch (e) {
      toastification.show(
        title: const Text('Error'),
        description: Text('Unable to save product. ${e.toString()}'),
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
