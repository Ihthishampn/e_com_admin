import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../../../general/services/image_service.dart';
import '../provider/category_provider.dart';
// model no longer constructed here; provider/repo handle image upload and model creation

class AddCategoryDialog extends StatefulWidget {
  final String? parentId;
  const AddCategoryDialog({
    this.parentId,
    super.key,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final nameController = TextEditingController();
  Uint8List? pickedBytes;
  bool isLoading = false;
  late final ImageServices imageService;

  @override
  void initState() {
    super.initState();
    imageService = ImageServices(
      FirebaseStorage.instance,
      ImagePicker(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        widget.parentId == null ? "Add Category" : "Add Subcategory",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // NAME FIELD
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Category name",
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // IMAGE PREVIEW
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                image: pickedBytes != null
                    ? DecorationImage(
                        image: MemoryImage(pickedBytes!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: pickedBytes == null
                  ? const Center(
                      child: Text(
                        "No image selected",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 10),

            // PICK IMAGE BUTTON
            OutlinedButton.icon(
              icon: const Icon(Icons.image_outlined),
              label: const Text("Select Image"),
              onPressed: _pickImage,
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: isLoading ? null : _addCategory,
          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final res = await imageService.pickImageFromDevice();
    res.fold(
      (l) {
        toastification.show(
          title: const Text("Failed to pick image"),
        );
      },
      (bytes) {
        setState(() => pickedBytes = bytes);
      },
    );
  }

  Future<void> _addCategory() async {
    if (nameController.text.trim().isEmpty) {
      toastification.show(
        title: const Text("Category name is required"),
      );
      return;
    }

    if (pickedBytes == null) {
      toastification.show(
        title: const Text("Category image is required"),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final categoryProvider = context.read<CategoryProvider>();
      final success = await categoryProvider.handleAddCategoryWithImage(
        name: nameController.text.trim(),
        imageBytes: pickedBytes!,
      );

      if (success) {
        Navigator.pop(context);
      }
    } catch (e) {
      toastification.show(
        title: Text("Error: $e"),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
