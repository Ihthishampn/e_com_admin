import 'dart:developer';
import 'dart:typed_data';
import 'dart:async';

import 'package:e_com_admin/features/products/data/use_case/product_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';

@injectable
class ProductProvider extends ChangeNotifier {
  final ProductsUseCase productsUseCase;

  bool isLoading = false;
  String? selectedCategoryId;
  String searchQuery = '';
  // internal debounce for search updates coming from UI
  Timer? _debounce;

  /// Returns the active product stream depending on selected category and query
  Stream<List<ProductModel>> get productsStream {
    final query = searchQuery.trim();
    if (query.isNotEmpty) {
      if (selectedCategoryId == null) {
        return productsUseCase.fetchProductsByQuery(query);
      }
      return productsUseCase.fetchProductsByQueryInCategory(
          query, selectedCategoryId!);
    }

    if (selectedCategoryId == null) return productsUseCase.fetchProducts();
    return productsUseCase.fetchProductsByCategory(selectedCategoryId!);
  }

  ProductProvider(this.productsUseCase);

  Stream<List<ProductModel>> handleProductFetch() {
    return productsUseCase.fetchProducts();
  }

  Stream<List<ProductModel>> handleProductsByCategory(String categoryId) {
    return productsUseCase.fetchProductsByCategory(categoryId);
  }

  Stream<List<ProductModel>> handleProductSearch(String query) {
    return productsUseCase.fetchProductsByQuery(query);
  }

  Stream<List<ProductModel>> handleProductSearchByCategory(
      String query, String categoryId) {
    return productsUseCase.fetchProductsByQueryInCategory(query, categoryId);
  }

  void selectCategory(String? categoryId) {
    _debounce?.cancel();
    selectedCategoryId = categoryId;
    searchQuery = '';
    notifyListeners();
  }

  void updateSearchQuery(String query,
      {Duration debounce = const Duration(milliseconds: 450)}) {
    _debounce?.cancel();
    _debounce = Timer(debounce, () {
      searchQuery = query.trim();
      notifyListeners();
    });
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
      log('ProductProvider.handleAddProductWithImages error: $e\n');
      log('ProductProvider.handleAddProductWithImages error',
          error: e);

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

  Future<bool> handleDeleteProduct(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      await productsUseCase.deleteProduct(id);
      toastification.show(
        title: const Text('Deleted'),
        description: const Text('Product deleted successfully'),
        backgroundColor: Colors.red,
      );
      return true;
    } catch (e) {
      log('ProductProvider.handleDeleteProduct error: $e');
      log('ProductProvider.handleDeleteProduct error',
          error: e);
      toastification.show(
        title: const Text('Error'),
        description: Text('Unable to delete product. ${e.toString()}'),
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> handleUpdateProductWithImages({
    required ProductModel product,
    required List<Uint8List> newImageBytes,
    required List<String> existingImageUrls,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await productsUseCase.updateProductWithImages(
        product: product,
        newImageBytes: newImageBytes,
        existingImageUrls: existingImageUrls,
      );
      toastification.show(
        title: const Text('Updated'),
        description: const Text('Product updated successfully'),
        backgroundColor: Colors.green,
      );
      return true;
    } catch (e) {
      log('ProductProvider.handleUpdateProductWithImages error: $e');
      log('ProductProvider.handleUpdateProductWithImages error',
          error: e);
      toastification.show(
        title: const Text('Error'),
        description: Text('Unable to update product. ${e.toString()}'),
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
