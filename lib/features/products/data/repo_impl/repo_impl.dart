import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_com_admin/features/products/domain/products_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/general/services/search_keyword_builder.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProductsRepo)
class ProductRepoImpl implements ProductsRepo {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProductRepoImpl(this.firestore)
      : storage = FirebaseStorage.instanceFor(app: Firebase.app());

  @override
  Stream<List<ProductModel>> getProducts() {
    return firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
            .toList();
      },
    );
  }

  @override
  Stream<List<ProductModel>> getProductsByCategory(String categoryId) {
    return firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
            .toList();
      },
    );
  }

  @override
  Future<void> addProductWithImages({
    required ProductModel product,
    required List<Uint8List> imageBytes,
  }) async {
    final uploadResults = await Future.wait(
      imageBytes.asMap().entries.map((entry) {
        final index = entry.key;
        final bytes = entry.value;
        final path =
            'ihthisham_stotage_product/${DateTime.now().millisecondsSinceEpoch}_$index.jpg';
        final ref = storage.ref().child(path);
        return ref
            .putData(
              bytes,
              SettableMetadata(contentType: 'image/jpeg'),
            )
            .then((task) => task.ref.getDownloadURL());
      }),
    );

    final docRef = firestore.collection('products').doc();
    final savedProduct = product.copyWith(
      id: docRef.id,
      images: uploadResults,
      searchKeywords: product.searchKeywords.isEmpty
          ? keywordsBuilder(product.productName)
          : product.searchKeywords,
    );

    await docRef.set(savedProduct.toMap());
  }
}
