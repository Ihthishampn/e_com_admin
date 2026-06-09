import 'dart:typed_data';

import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/features/products/domain/products_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ProductsUseCase {
  final ProductsRepo productsRepo;

  ProductsUseCase(this.productsRepo);

  Stream<List<ProductModel>> fetchProducts() {
    return productsRepo.getProducts();
  }

  Stream<List<ProductModel>> fetchProductsByCategory(String categoryId) {
    return productsRepo.getProductsByCategory(categoryId);
  }

  Stream<List<ProductModel>> fetchProductsByQuery(String query) {
    return productsRepo.searchProducts(query);
  }

  Stream<List<ProductModel>> fetchProductsByQueryInCategory(
      String query, String categoryId) {
    return productsRepo.searchProductsByCategory(query, categoryId);
  }

  Future<void> addProductWithImages({
    required ProductModel product,
    required List<Uint8List> imageBytes,
  }) {
    return productsRepo.addProductWithImages(
      product: product,
      imageBytes: imageBytes,
    );
  }

  Future<void> deleteProduct(String id) {
    return productsRepo.deleteProduct(id);
  }

  Future<void> updateProductWithImages({
    required ProductModel product,
    required List<Uint8List> newImageBytes,
    required List<String> existingImageUrls,
  }) {
    return productsRepo.updateProductWithImages(
      product: product,
      newImageBytes: newImageBytes,
      existingImageUrls: existingImageUrls,
    );
  }
}
