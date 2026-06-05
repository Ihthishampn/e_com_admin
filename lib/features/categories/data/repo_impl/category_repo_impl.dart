import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_com_admin/features/categories/data/model/category_model.dart';
import 'package:e_com_admin/features/categories/domain/repo/categories_repo.dart';
import 'package:e_com_admin/general/services/search_keyword_builder.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoriesRepo)
class CategoryRepoImpl implements CategoriesRepo {
  final FirebaseFirestore firebaseFirestore;
  CategoryRepoImpl(this.firebaseFirestore);

  @override
  Future<void> addCategory(
      {required String name, required Uint8List imageBytes}) async {
    try {
      final docref = firebaseFirestore.collection("categories").doc();
      log("firebase id taken : ${docref.id}");

      // Upload the image to the ihthisham storage bucket/folder
      final storage = FirebaseStorage.instance;
      final String imageName =
          "ihthisham_stotage_category/${DateTime.now().microsecondsSinceEpoch}.webp";

      await storage.ref(imageName).putData(
            imageBytes,
            SettableMetadata(
              contentType: 'image/webp',
              customMetadata: {'access': 'public'},
              cacheControl: 'public, max-age=3600',
            ),
          );
      final downloadUrl = await storage.ref(imageName).getDownloadURL();
      log("Image uploaded to: $downloadUrl");

      final newCategory = CategoryModel(
        id: docref.id,
        name: name,
        imageUrl: downloadUrl,
        createdAt: DateTime.now(),
        searchKeywords: keywordsBuilder(name),
      );

      await docref.set(newCategory.toJson());
    } catch (e) {
      log(
        'addCategory failed',
        error: e,
      );
    }
  }

  @override
  Future<void> deleteCategory({required String id}) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<void> editCategory({
    required String uid,
    required CategoryModel editCategoryData,
  }) {
    // TODO: implement editCategory
    throw UnimplementedError();
  }

  @override
  Stream<List<CategoryModel>> getCategory() {
    return firebaseFirestore.collection("categories").snapshots().map(
      (event) {
        return event.docs.map(
          (e) {
            return CategoryModel.fromJson(e.data());
          },
        ).toList();
      },
    );
  }
}
