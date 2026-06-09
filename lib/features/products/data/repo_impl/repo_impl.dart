import 'dart:developer';
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
        .handleError((e, st) {
 
      log('Firestore getProducts snapshot error: $e');
      log('Firestore getProducts snapshot error', error: e, stackTrace: st);
    }).map(
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
        .handleError((e, st) {
      log('Firestore getProductsByCategory snapshot error: $e');
      log('Firestore getProductsByCategory snapshot error',
          error: e, stackTrace: st);
    }).map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
            .toList();
      },
    );
  }

  @override
  Stream<List<ProductModel>> searchProducts(String query) {
    final raw = query.trim().toLowerCase();

    final normalized =
        raw.replaceAll(RegExp(r'[^a-z0-9\s]'), '').replaceAll(' ', '');
    if (normalized.isEmpty) return getProducts();

    return firestore
        .collection('products')
        .where('searchKeywords', arrayContains: normalized)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((e, st) {
      log('Firestore searchProducts snapshot error: $e');
      log('Firestore searchProducts snapshot error', error: e, stackTrace: st);
    }).map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Stream<List<ProductModel>> searchProductsByCategory(
      String query, String categoryId) {
    final raw = query.trim().toLowerCase();

    final normalized =
        raw.replaceAll(RegExp(r'[^a-z0-9\s]'), '').replaceAll(' ', '');
    if (normalized.isEmpty) return getProductsByCategory(categoryId);

    return firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('searchKeywords', arrayContains: normalized)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((e, st) {
      log('Firestore searchProductsByCategory snapshot error: $e');
      log('Firestore searchProductsByCategory snapshot error',
          error: e, stackTrace: st);
    }).map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    });
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

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final docRef = firestore.collection('products').doc(id);
      await docRef.delete();
    } catch (e, st) {
      log('Firestore deleteProduct error: $e');
      log('Firestore deleteProduct error', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> updateProductWithImages({
    required ProductModel product,
    required List<Uint8List> newImageBytes,
    required List<String> existingImageUrls,
  }) async {
    try {
      final uploadResults = await Future.wait(
        newImageBytes.asMap().entries.map((entry) {
          final index = entry.key;
          final bytes = entry.value;
          final path =
              'ihthisham_stotage_product/${DateTime.now().millisecondsSinceEpoch}_upd_$index.jpg';
          final ref = storage.ref().child(path);
          return ref
              .putData(
                bytes,
                SettableMetadata(contentType: 'image/jpeg'),
              )
              .then((task) => task.ref.getDownloadURL());
        }),
      );

      final mergedImages = [...existingImageUrls, ...uploadResults];

      final docRef = firestore.collection('products').doc(product.id);
      final savedProduct = product.copyWith(
        images: mergedImages,
        searchKeywords: product.searchKeywords.isEmpty
            ? keywordsBuilder(product.productName)
            : product.searchKeywords,
      );

      await docRef.set(savedProduct.toMap());
    } catch (e, st) {
      // ignore: avoid_print
      print('Firestore updateProductWithImages error: $e');
      log('Firestore updateProductWithImages error', error: e, stackTrace: st);
      rethrow;
    }
  }
}
