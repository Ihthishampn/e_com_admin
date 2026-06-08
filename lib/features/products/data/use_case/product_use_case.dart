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

  Future<void> addProductWithImages({
    required ProductModel product,
    required List<Uint8List> imageBytes,
  }) {
    return productsRepo.addProductWithImages(
      product: product,
      imageBytes: imageBytes,
    );
  }
}
