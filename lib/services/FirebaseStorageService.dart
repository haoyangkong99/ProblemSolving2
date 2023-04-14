import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  File convertXFileToFile(XFile? xfile) {
    return File(xfile!.path);
  }

  List<File> convertXFilesToFile(List<XFile?> xfiles) {
    return xfiles.map((e) => File(e!.path)).toList();
  }

  Future<String> uploadFileToStorage(File? file) async {
    final fileName = file!.path.split('/').last;
    final destination = 'files/$fileName';
    try {
      final ref = storage.ref(destination);
      var snapshot = await ref.putFile(file);
      final urlDownload = snapshot.ref.getDownloadURL().whenComplete(() {});
      return urlDownload;
    } on FirebaseException catch (error) {
      throw FirebaseException(
          code: error.code, message: error.message, plugin: '');
    }
  }

  Future<String> uploadImageToStorage(File? file) async {
    final fileName = file!.path.split('/').last;
    final destination = 'images/$fileName';
    try {
      final ref = storage.ref(destination);
      var snapshot = await ref.putFile(file);
      final urlDownload = snapshot.ref.getDownloadURL().whenComplete(() {});
      return urlDownload;
    } on FirebaseException catch (error) {
      throw FirebaseException(
          code: error.code, message: error.message, plugin: '');
    }
  }

  Future<List<String>> uploadMultipleImagesToStorage(List<File?> files) async {
    try {
      List<String> uploadedFileUrls = [];
      for (int i = 0; i < files.length; i++) {
        final fileName = files[i]!.path.split('/').last;
        final destination = 'images/$fileName';
        final ref = storage.ref(destination);
        var snapshot = await ref.putFile(files[i]!);
        String url = await snapshot.ref.getDownloadURL();
        uploadedFileUrls.add(url);
      }
      return uploadedFileUrls;
    } on FirebaseException catch (error) {
      throw FirebaseException(
          code: error.code, message: error.message, plugin: '');
    }
  }

  Future<String> uploadVideoToStorage(File? file) async {
    final fileName = file!.path.split('/').last;
    final destination = 'videos/$fileName';
    try {
      final ref = storage.ref(destination);
      var snapshot = await ref.putFile(file);
      final urlDownload = snapshot.ref.getDownloadURL().whenComplete(() {});
      return urlDownload;
    } on FirebaseException catch (error) {
      throw FirebaseException(
          code: error.code, message: error.message, plugin: '');
    }
  }

  List<Future<String>> uploadMultipleVideosToStorage(List<File?> files) {
    try {
      List<Future<String>> urlFiles = files.map((file) async {
        final fileName = file!.path.split('/').last;
        final destination = 'videos/$fileName';
        final ref = storage.ref(destination);
        var snapshot = await ref.putFile(file);
        return snapshot.ref.getDownloadURL().whenComplete(() {});
      }).toList();
      return urlFiles;
    } on FirebaseException catch (error) {
      throw FirebaseException(
          code: error.code, message: error.message, plugin: '');
    }
  }

  Future<bool> deleteFromStorage(String? url) async {
    try {
      await storage.refFromURL(url!).delete();
    } on FirebaseException catch (error) {
      throw FirebaseException(
          code: error.code, message: error.message, plugin: '');
    }
    return true;
  }
}
