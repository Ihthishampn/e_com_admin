import 'dart:typed_data';
import 'package:e_com_admin/general/services/image_service.dart';
import 'package:e_com_admin/general/widgets/add_image_containers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagePickerLayout extends StatelessWidget {
  final List<Uint8List> selectedImages;
  final Function(List<Uint8List>) onImagesSelected;
  final Function(Uint8List) onImageRemoved;

  const ImagePickerLayout({
    Key? key,
    required this.selectedImages,
    required this.onImagesSelected,
    required this.onImageRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        GestureDetector(
          onTap: () async {
            final imageService = ImageServices(
              FirebaseStorage.instance,
              ImagePicker(),
            );
            final res = await imageService.pickMultipleImageFromDevice(
              maxImages: 5,
            );
            res.fold((l) => null, (list) {
              onImagesSelected([...selectedImages, ...list]);
            });
          },
          child: SizedBox(
            width: 120,
            height: 120,
            child: AddImageContainer(
              width: 120,
              height: 120,
              aspectRatioValue: 1.0,
              aspectRatio: "1:1",
            ),
          ),
        ),
        for (var bytes in selectedImages)
          Stack(
            children: [
              Image.memory(bytes, width: 120, height: 120, fit: BoxFit.cover),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () => onImageRemoved(bytes),
                  child: Container(
                    color: Colors.black45,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
