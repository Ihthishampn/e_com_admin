import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_com_admin/general/widgets/custom_cached_network_image.dart';

class CategoryCardLayout extends StatelessWidget {
  final String categoryId;
  final String title;
  final String imageUrl;
  final Uint8List? imageBytes;
  final VoidCallback? onDelete;

  const CategoryCardLayout({
    super.key,
    required this.categoryId,
    required this.title,
    required this.imageUrl,
    this.imageBytes,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade100,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              final imageParam = Uri.encodeComponent(imageUrl);

              context.go(
                '/categories/products?id=$categoryId&name=$title&image=$imageParam',
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageBytes != null
                            ? Image.memory(
                                imageBytes!,
                                fit: BoxFit.cover,
                              )
                            : imageUrl.isNotEmpty
                                ? CustomCachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Delete action intentionally removed from category card.
        ],
      ),
    );
  }
}
