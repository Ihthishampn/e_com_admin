import 'dart:typed_data';

import 'package:e_com_admin/features/products/data/model/product_model.dart';

abstract class ProductsRepo {
  Stream<List<ProductModel>> getProducts();
  Stream<List<ProductModel>> getProductsByCategory(String categoryId);
  Stream<List<ProductModel>> searchProducts(String query);
  Stream<List<ProductModel>> searchProductsByCategory(
      String query, String categoryId);
  Future<void> deleteProduct(String id);
  Future<void> updateProductWithImages({
    required ProductModel product,
    required List<Uint8List> newImageBytes,
    required List<String> existingImageUrls,
    required List<String> originalImageUrls,
  });
  Future<void> addProductWithImages({
    required ProductModel product,
    required List<Uint8List> imageBytes,
  });
}
