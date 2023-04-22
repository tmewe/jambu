import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class PhotoStorageRepository {
  const PhotoStorageRepository({
    required FirebaseStorage storage,
  }) : _storage = storage;

  final FirebaseStorage _storage;

  static const _directoryName = 'photos';

  Future<String?> uploadPhotoData({
    required Uint8List data,
    required String userName,
  }) async {
    final photoName = '${userName.split(' ').join('_')}.png';
    final photoRef = _storage.ref('$_directoryName/$photoName');

    try {
      await photoRef.putData(data);
    } on FirebaseException catch (_) {
      return null;
    }
    return photoRef.getDownloadURL();
  }
}
