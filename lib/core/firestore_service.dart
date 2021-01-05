import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starterkit_firebase/core/custom_exception.dart';

// https://github.com/bizz84/codewithandrea_flutter_packages/blob/master/packages/firestore_service/lib/firestore_service.dart
class FirestoreService {
  FirestoreService({FirebaseFirestore firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Generate a new id on path. (i.e /path_collection/{id_documentId})
  String generateIDForCollection(String path) => _firestore.collection(path).doc().id;

  Future<void> setDocData({
    @required String path,
    @required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      final reference = _firestore.doc(path);
      await reference.set(data, SetOptions(merge: merge));
    } on Exception catch (e) {
      throw ClientException('could not upload item', exception: e);
    }
  }

  Future<void> setCollectionData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    try {
      final reference = _firestore.collection(path);
      await reference.add(data);
    } on Exception catch (e) {
      final error = e;
      throw ClientException('could not upload item', exception: error);
    }
  }

  Future<void> deleteData({@required String path}) async {
    final reference = _firestore.doc(path);
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) {
    Query query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final reference = _firestore.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
