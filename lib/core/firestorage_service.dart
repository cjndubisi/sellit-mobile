import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_starterkit_firebase/core/custom_exception.dart';
import 'package:flutter_starterkit_firebase/utils/repository.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FirebaseStorageService {
  FirebaseStorageService({
    FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage ?? FirebaseStorage();

  final FirebaseStorage _firebaseStorage;

  Future<List<String>> uploadImages({ String fileName, List<Asset> assets}) async {
    final uploadUrls = <String>[];
    try {
      await Future.wait(
          assets.map((Asset asset) async {
            final byteData = await asset.getByteData(quality: 50);
            final imageData = byteData.buffer.asUint8List();

            final reference =
                _firebaseStorage.ref().child(fileName + Repository.getInstance().getRef() + '.png');
            final uploadTask = reference.putData(imageData);
            StorageTaskSnapshot storageTaskSnapshot;

            final snapshot = await uploadTask.onComplete;
            if (snapshot.error == null) {
              storageTaskSnapshot = snapshot;
              final dynamic downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
              uploadUrls.add(downloadUrl.toString());

              print('Upload success');
            } else {
              print('Error from image repo ${snapshot.error.toString()}');
              throw 'This file is not an image';
            }
          }),
          eagerError: true,
          cleanUp: (dynamic e) {
            print('eager cleaned up');
          });

      return uploadUrls;
    } on Exception catch (e) {
      throw ClientException('failed to upload images', exception: e);
    }
  }
}
