import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:e_com_admin/features/products/data/model/product_model.dart';
import 'package:e_com_admin/features/products/presentation/provider/product_provider.dart';

@injectable
class AddProductProvider extends ChangeNotifier {
  final ProductProvider productProvider;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortNoteController = TextEditingController();
  final TextEditingController additionalNoteController =
      TextEditingController();

  List<String> existingImageUrls = [];
  List<Uint8List> selectedImages = [];

  String? selectedCategoryId;
  int variantCount = 1;
  int detailCount = 1;
  List<ProductVariant> variants = [];
  List<ProductDetail> details = [];
  bool isHot = false;
  double rating = 1.0;

  bool _prefilled = false;
  bool get prefilled => _prefilled;

  StreamSubscription<List<ProductModel>>? _productSub;

  AddProductProvider(this.productProvider);

  void disposeControllers() {
    nameController.dispose();
    shortNoteController.dispose();
    additionalNoteController.dispose();
    _productSub?.cancel();
  }

  void setSelectedCategory(String? id) {
    selectedCategoryId = id;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void updateSearchableFieldsFromUI() {
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void addSelectedImages(List<Uint8List> newImages) {
    selectedImages = [...selectedImages, ...newImages];
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void removeSelectedImage(Uint8List bytes) {
    selectedImages.remove(bytes);
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void removeExistingImage(String url) {
    existingImageUrls.remove(url);
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setVariants(List<ProductVariant> list) {
    variants = list;
    variantCount = list.length > 0 ? list.length : 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setDetails(List<ProductDetail> list) {
    details = list;
    detailCount = list.length > 0 ? list.length : 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void addVariantSlot() {
    variantCount += 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void removeVariantSlot() {
    if (variantCount > 1) {
      variantCount -= 1;
      if (variants.length >= variantCount) variants.removeLast();
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void addDetailSlot() {
    detailCount += 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void removeDetailSlot() {
    if (detailCount > 1) {
      detailCount -= 1;
      if (details.length >= detailCount) details.removeLast();
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void initForEdit(String productId) {
    if (_prefilled) return;
    _productSub = productProvider.productsStream.listen((products) {
      final matches = products.where((p) => p.id == productId);
      if (matches.isNotEmpty && !_prefilled) {
        final prod = matches.first;
        _prefilled = true;
        nameController.text = prod.productName;
        shortNoteController.text = prod.shortNote;
        additionalNoteController.text = prod.additionalNote;
        selectedCategoryId =
            prod.categoryId.isNotEmpty ? prod.categoryId : null;
        existingImageUrls = List<String>.from(prod.images);
        variants = List<ProductVariant>.from(prod.variants);
        details = List<ProductDetail>.from(prod.details);
        variantCount = variants.isNotEmpty ? variants.length : 1;
        detailCount = details.isNotEmpty ? details.length : 1;
        isHot = prod.isHot;
        rating = prod.rating;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
          _productSub?.cancel();
        });
      }
    });
  }

  void setRating(double v) {
    rating = v;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setIsHot(bool v) {
    isHot = v;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
