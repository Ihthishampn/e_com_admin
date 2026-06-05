import 'dart:typed_data';

import 'package:e_com_admin/features/products/data/model/product_model.dart';

abstract class ProductsRepo {
  Stream<List<ProductModel>> getProducts();
  Stream<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<void> addProductWithImages({
    required ProductModel product,
    required List<Uint8List> imageBytes,
  });
}