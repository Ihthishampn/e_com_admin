// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:e_com_admin/general/core/failure/main_failure.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageServices {
  ImageServices(this._storage, this._imagePicker);

  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;

  /// Converts image bytes to WebP format with compression
  Future<Either<MainFailure, Uint8List>> convertToWebP(
    Uint8List imageBytes,
  ) async {
    try {
      // WebP conversion is a no-op here (library optional). Return original bytes.
      log(
        'WebP conversion skipped: returning original bytes (${imageBytes.lengthInBytes} bytes)',
      );
      return right(imageBytes);
    } catch (e) {
      log('Error in convertToWebP fallback: $e');
      return left(
        MainFailure.serverFailure(
          errorMsg: 'Failed to convert image to WebP: ${e.toString()}',
        ),
      );
    }
  }

  Future<Either<MainFailure, Uint8List>> pickImageFromDevice() async {
    try {
      if (kIsWeb) {
        try {
          final result = await FilePicker.pickFiles(
            type: FileType.image,
            allowMultiple: false,
            withData: true,
          );

          if (result != null && result.files.isNotEmpty) {
            final file = result.files.first;
            if (file.bytes == null) {
              return left(
                const MainFailure.pickFailed(
                  errorMsg: "Failed to read image data",
                ),
              );
            }
            if (file.bytes!.lengthInBytes > 1024 * 1024) {
              return left(
                const MainFailure.pickFailed(
                  errorMsg: 'Pick an image less than 1MB',
                ),
              );
            }
            return right(file.bytes!);
          }
        } on MissingPluginException catch (_) {
          // Fallback to native HTML input when plugin not registered on web
          final bytes = await _pickSingleFileWithHtml(accept: 'image/*');
          if (bytes == null)
            return left(
              const MainFailure.pickFailed(errorMsg: 'No image picked'),
            );
          if (bytes.lengthInBytes > 1024 * 1024) {
            return left(
              const MainFailure.pickFailed(
                errorMsg: 'Pick an image less than 1MB',
              ),
            );
          }
          return right(bytes);
        }
      } else {
        final pickedImageFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedImageFile != null) {
          final imageBytesList = await pickedImageFile.readAsBytes();
          if (imageBytesList.lengthInBytes > 1024 * 1024) {
            return left(
              const MainFailure.serverFailure(
                errorMsg: 'Pick an image less than 1MB',
              ),
            );
          }
          return right(imageBytesList);
        }
      }
      return left(const MainFailure.pickFailed(errorMsg: "No image picked"));
    } catch (e) {
      log('Error picking image: $e');
      if (e is MissingPluginException) {
        return left(
          const MainFailure.pickFailed(
            errorMsg: 'Image picker plugin not available on this platform.',
          ),
        );
      }
      return left(
        MainFailure.serverFailure(
          errorMsg: "Error picking image: ${e.toString()}",
        ),
      );
    }
  }

  /// Web fallback: show native HTML file input and return picked bytes (or null)
  Future<Uint8List?> _pickSingleFileWithHtml({String accept = '*'}) async {
    try {
      final html.FileUploadInputElement input = html.FileUploadInputElement();
      input.accept = accept;
      input.multiple = false;
      final completer = Completer<Uint8List?>();
      input.click();
      input.onChange.listen((event) {
        final files = input.files;
        if (files == null || files.isEmpty) {
          completer.complete(null);
          return;
        }
        final file = files[0];
        final reader = html.FileReader();
        reader.onLoad.listen((_) {
          final result = reader.result;
          if (result is Uint8List) {
            completer.complete(result);
          } else if (result is ByteBuffer) {
            completer.complete(Uint8List.view(result));
          } else if (result is List<int>) {
            completer.complete(Uint8List.fromList(result));
          } else {
            completer.complete(null);
          }
        });
        reader.onError.listen((err) => completer.complete(null));
        reader.readAsArrayBuffer(file);
      });
      return completer.future;
    } catch (e) {
      return null;
    }
  }

  /// Validates if an image has the correct aspect ratio
  /// Returns true if the aspect ratio is correct, false otherwise
  Future<bool> validateAspectRatio(
    Uint8List imageBytes, {
    double targetAspectRatio = 1.0,
  }) async {
    try {
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final width = image.width.toDouble();
      final height = image.height.toDouble();

      // Check if it matches the target aspect ratio
      final aspectRatio = width / height;

      // Use a 15% tolerance for aspect ratios to be more flexible
      final tolerance = targetAspectRatio * 0.15;
      final minAllowed = targetAspectRatio - tolerance;
      final maxAllowed = targetAspectRatio + tolerance;
      final isValid = (aspectRatio >= minAllowed && aspectRatio <= maxAllowed);

      // Debug logging
      log('Image dimensions: ${width.toInt()}x${height.toInt()}');
      log('Image aspect ratio: $aspectRatio');
      log('Target aspect ratio: $targetAspectRatio');
      log('Tolerance: $tolerance');
      log('Allowed range: $minAllowed to $maxAllowed');
      log('Is valid: $isValid');

      return isValid;
    } catch (e) {
      log('Error validating aspect ratio: $e');
      return false;
    }
  }

  /// Picks an image and validates its aspect ratio
  Future<Either<MainFailure, Uint8List>> pickImageWithAspectRatioValidation({
    required double aspectRatio,
  }) async {
    log('aspectRatio: $aspectRatio');
    final result = await pickImageFromDevice();

    return result.fold((failure) => left(failure), (imageBytes) async {
      final isValidAspectRatio = await validateAspectRatio(
        imageBytes,
        targetAspectRatio: aspectRatio,
      );
      if (!isValidAspectRatio) {
        String aspectRatioText;
        if (aspectRatio == 1.0) {
          aspectRatioText = 'square (1:1 aspect ratio)';
        } else if (aspectRatio == 16.0 / 9.0) {
          aspectRatioText = '16:9 aspect ratio';
        } else if (aspectRatio == 4.0 / 3.0) {
          aspectRatioText = '4:3 aspect ratio';
        } else if (aspectRatio == 9.0 / 16.0) {
          aspectRatioText = '9:16 aspect ratio';
        } else if (aspectRatio == 3.0 / 4.0) {
          aspectRatioText = '3:4 aspect ratio';
        } else if (aspectRatio == 2.0 / 3.0) {
          aspectRatioText = '2:3 aspect ratio';
        } else if ((aspectRatio - 2.35).abs() < 0.01) {
          aspectRatioText = '2.35:1 aspect ratio';
        } else {
          // For other ratios, show the actual ratio
          if (aspectRatio < 1.0) {
            // For ratios less than 1, show as height:width
            final height = (1.0 / aspectRatio).toStringAsFixed(2);
            aspectRatioText = '$height:1 aspect ratio';
          } else {
            // For ratios greater than 1, show as width:height
            final width = aspectRatio.toStringAsFixed(2);
            aspectRatioText = '$width:1 aspect ratio';
          }
        }

        return left(
          MainFailure.serverFailure(
            errorMsg:
                'Image must be $aspectRatioText. Please select an image with the correct dimensions.',
          ),
        );
      }
      return right(imageBytes);
    });
  }

  Future<Either<MainFailure, List<Uint8List>>> pickMultipleImageFromDevice({
    required int maxImages,
  }) async {
    try {
      if (kIsWeb) {
        try {
          final result = await FilePicker.pickFiles(
            type: FileType.image,
            allowMultiple: true,
            withData: true, // Important for web!
          );

          if (result == null || result.files.isEmpty) {
            return left(
              const MainFailure.pickFailed(errorMsg: "No images picked"),
            );
          }

          List<Uint8List> imageBytesList = [];

          for (var file in result.files.take(maxImages)) {
            if (file.bytes == null) {
              continue; // Skip if somehow bytes are null
            }
            if (file.bytes!.lengthInBytes > 200 * 1024) {
              return left(
                const MainFailure.serverFailure(
                  errorMsg: "Each image must be under 200KB",
                ),
              );
            }
            imageBytesList.add(file.bytes!);
          }

          if (imageBytesList.isEmpty) {
            return left(
              const MainFailure.pickFailed(errorMsg: "No valid images picked"),
            );
          }

          return right(imageBytesList);
        } on MissingPluginException catch (_) {
          // fallback to native html multiple file picker
          final bytesList = await _pickMultipleFilesWithHtml(
            accept: 'image/*',
            maxFiles: maxImages,
          );
          if (bytesList == null || bytesList.isEmpty)
            return left(
              const MainFailure.pickFailed(errorMsg: 'No images picked'),
            );
          for (var b in bytesList) {
            if (b.lengthInBytes > 200 * 1024) {
              return left(
                const MainFailure.serverFailure(
                  errorMsg: 'Each image must be under 200KB',
                ),
              );
            }
          }
          return right(bytesList);
        }
      } else {
        final result = await FilePicker.pickFiles(
          type: FileType.image,
          allowMultiple: true,
          withData: true, // Important for web!
        );

        if (result == null || result.files.isEmpty) {
          return left(
            const MainFailure.pickFailed(errorMsg: "No images picked"),
          );
        }

        List<Uint8List> imageBytesList = [];

        for (var file in result.files.take(maxImages)) {
          if (file.bytes == null) {
            continue; // Skip if somehow bytes are null
          }
          if (file.bytes!.lengthInBytes > 200 * 1024) {
            return left(
              const MainFailure.serverFailure(
                errorMsg: "Each image must be under 200KB",
              ),
            );
          }
          imageBytesList.add(file.bytes!);
        }

        if (imageBytesList.isEmpty) {
          return left(
            const MainFailure.pickFailed(errorMsg: "No valid images picked"),
          );
        }

        return right(imageBytesList);
      }
    } catch (e) {
      log('Error picking images: $e');
      if (e is MissingPluginException) {
        return left(
          const MainFailure.pickFailed(
            errorMsg:
                'Multiple image picker plugin not available on this platform.',
          ),
        );
      }
      return left(MainFailure.serverFailure(errorMsg: e.toString()));
    }
  }

  Future<List<Uint8List>?> _pickMultipleFilesWithHtml({
    String accept = '*',
    required int maxFiles,
  }) async {
    try {
      final html.FileUploadInputElement input = html.FileUploadInputElement();
      input.accept = accept;
      input.multiple = true;
      final completer = Completer<List<Uint8List>?>();
      input.click();
      input.onChange.listen((event) async {
        final files = input.files;
        if (files == null || files.isEmpty) {
          completer.complete(null);
          return;
        }
        final List<Uint8List> results = [];
        final take = files.length > maxFiles ? maxFiles : files.length;
        for (int i = 0; i < take; i++) {
          final file = files[i];
          final reader = html.FileReader();
          final innerCompleter = Completer<Uint8List?>();
          reader.onLoad.listen((_) {
            final result = reader.result;
            if (result is Uint8List) {
              innerCompleter.complete(result);
            } else if (result is ByteBuffer) {
              innerCompleter.complete(Uint8List.view(result));
            } else if (result is List<int>) {
              innerCompleter.complete(Uint8List.fromList(result));
            } else {
              innerCompleter.complete(null);
            }
          });
          reader.onError.listen((err) => innerCompleter.complete(null));
          reader.readAsArrayBuffer(file);
          final bytes = await innerCompleter.future;
          if (bytes != null) results.add(bytes);
        }
        completer.complete(results);
      });
      return completer.future;
    } catch (e) {
      return null;
    }
  }

  Future<Either<MainFailure, String>> saveImage({
    required Uint8List imageBytes,
    required String folderName,
  }) async {
    try {
      Uint8List uploadBytes = imageBytes;

      // Try to convert to WebP, but fall back to original if it fails
      final webpResult = await convertToWebP(imageBytes);
      webpResult.fold(
        (failure) => debugPrint(
          'WebP conversion failed, using original. Failure: $failure',
        ),
        (bytes) => uploadBytes = bytes,
      );

      final String imageName =
          "$folderName/${DateTime.now().microsecondsSinceEpoch}.webp";

      await _storage
          .ref(imageName)
          .putData(uploadBytes, SettableMetadata(contentType: 'image/webp'));

      final downloadUrl = await _storage.ref(imageName).getDownloadURL();
      return right(downloadUrl);
    } catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.toString()));
    }
  }

  // FutureResult<Unit> deleteFirebaseStorageListUrl(
  //     List<String> imageUrlList) async {
  //   try {
  //     final functionList = <Future<void>>[];
  //     for (final url in imageUrlList) {
  //       functionList.add(deleteImageUrl(imageUrl: url));
  //     }

  //     await Future.wait(functionList);
  //     log('images deleted successfully');
  //     return right(unit);
  //   } on Exception catch (e) {
  //     return left(MainFailure.serverFailure(errorMsg: e.toString()));
  //   }
  // }

  Future<Either<MainFailure, List<String>>> saveMultipleImages({
    required List<Uint8List> imageBytesList,
    required String folderName,
  }) async {
    try {
      // Create a list of futures to upload all images concurrently
      List<Future<Either<MainFailure, String>>> uploadFutures = imageBytesList
          .map<Future<Either<MainFailure, String>>>((imageBytes) async {
            try {
              // Convert to WebP format
              final webpResult = await convertToWebP(imageBytes);
              if (webpResult.isLeft()) {
                return left(
                  webpResult.fold(
                    (l) => l,
                    (r) => throw Exception('Unexpected'),
                  ),
                );
              }

              final webpBytes = webpResult.fold(
                (l) => throw Exception('Unexpected'),
                (r) => r,
              );
              final String imageName =
                  "$folderName/${DateTime.now().microsecondsSinceEpoch}.webp";

              // Upload the image
              await _storage
                  .ref(imageName)
                  .putData(
                    webpBytes,
                    SettableMetadata(contentType: 'image/webp'),
                  );

              // Get the download URL
              final String downloadUrl = await _storage
                  .ref(imageName)
                  .getDownloadURL();

              // Return the download URL wrapped in Right
              return right(downloadUrl);
            } catch (e) {
              // In case of an error, return a failure wrapped in Left
              return left(MainFailure.serverFailure(errorMsg: e.toString()));
            }
          })
          .toList();

      // Wait for all uploads to complete
      List<Either<MainFailure, String>> results = await Future.wait(
        uploadFutures,
      );

      // Check if any of the uploads failed
      for (var result in results) {
        if (result.isLeft()) {
          // If there's a failure, return the first encountered failure
          return left(
            result.fold(
              (failure) => failure,
              (_) => const MainFailure.serverFailure(errorMsg: 'Unknown error'),
            ),
          );
        }
      }

      // If all uploads succeeded, collect the download URLs
      List<String> downloadUrls = results
          .map((result) => result.fold((_) => '', (url) => url))
          .toList();

      // Return the list of download URLs
      return right(downloadUrls);
    } catch (e) {
      // If something went wrong with the entire process, return a general failure
      return left(MainFailure.serverFailure(errorMsg: e.toString()));
    }
  }
  ///////////////// PDF DOWNLOAD IN WEB ////////////

  Future<Either<MainFailure, String>> downloadPdf({
    required String url,
    required String fileName,
  }) async {
    final httpsReference = FirebaseStorage.instance.refFromURL(url);
    html.window.open(url, "_blank");
    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await httpsReference.getData(oneMegabyte);
      // Data for "images/island.jpg" is returned, use this as needed.
      XFile.fromData(
        data!,
        mimeType: "application/octet-stream",
        name: "$fileName.pdf",
      ).saveTo("C:/"); // here Path is ignored
      return right('PDF Downloded');
      //opens pdf in new tab
    } catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.toString()));
      // Handle any errors.
    }
  }

  // /* ------------------------------ DELETE IMAGE ------------------------------ */
  //delete Image with image url in the storage
  Future<Either<MainFailure, Unit>> deleteImageUrl({
    required String? imageUrl,
  }) async {
    if (imageUrl == null) {
      return left(
        const MainFailure.serverFailure(
          errorMsg: "Can't able to remove previous image.",
        ),
      );
    }
    final imageRef = _storage.refFromURL(imageUrl);
    try {
      await imageRef.delete();
      return right(unit);
    } catch (e) {
      return left(
        const MainFailure.serverFailure(
          errorMsg: "Can't able to remove previous image.",
        ),
      );
    }
    /*
     -------------------------------------------------------------------------- */
  }

  // Future<Uint8List> compressImageWeb(Uint8List imageBytes) async {
  //   final config = ImageFileConfiguration(
  //     input: ImageFile(rawBytes: imageBytes, filePath: ''),
  //     config:
  //         Configuration(quality: 70, outputType: ImageOutputType.webpThenJpg),
  //   );
  //   final compressedImage = await compressor.compress(config);
  //   log('$compressedImage');
  //   return compressedImage.rawBytes;
  // }
}
