

import 'package:e_com_admin/general/utils/themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

class AddImageContainer extends StatelessWidget {
  final double width;
  final double? height;
  final String? suggestedFormats;
  final String? recommendedSize;
  final String? aspectRatio;
  final bool? isFetching;
  final double aspectRatioValue;

  const AddImageContainer(
      {super.key,
      required this.width,
      this.height,
      this.suggestedFormats,
      this.recommendedSize,
      this.aspectRatio,
      this.isFetching,
      this.aspectRatioValue = 16 / 9});

  double get calculatedHeight => height ?? (width * (9 / 16));

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: aspectRatioValue, // Ensuring a strict 16:9 ratio
        child: Container(
          width: width,
          height: calculatedHeight,
          decoration: BoxDecoration(
            border: RDottedLineBorder.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: isFetching == true
              ? Center(
                  child: CupertinoActivityIndicator(
                  color: AppColors.black,
                ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 30, color: AppColors.black),
                    const SizedBox(height: 5),
                    const Text(
                      'Add Image',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    if (aspectRatio != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Aspect Ratio: $aspectRatio',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.greyColor),
                        ),
                      ),
                    if (recommendedSize != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Recommended Size: $recommendedSize',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.greyColor),
                        ),
                      ),
                    if (suggestedFormats != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Suggested format: $suggestedFormats',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.greyColor),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

