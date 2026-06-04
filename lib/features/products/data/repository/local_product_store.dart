import 'package:flutter/foundation.dart';
import '../model/product_model.dart';

class LocalProductStore {
  LocalProductStore._internal();

  static final LocalProductStore instance = LocalProductStore._internal();

  final ValueNotifier<List<ProductModel>> products = ValueNotifier([]);

  void addProduct(ProductModel p) {
    products.value = [...products.value, p];
  }

  void clear() {
    products.value = [];
  }
}
