import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image != null ? File(image.path) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<File?> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      return image != null ? File(image.path) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<File>> pickMultiple() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      return [];
    }
  }
}