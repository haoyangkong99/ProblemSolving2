import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDbService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> validateDocumentExist(
      String collectionPath, String documentId) async {
    return await db
        .collection(collectionPath)
        .doc(documentId)
        .get()
        .then((value) => value.exists);
  }

  Future<bool> addDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    try {
      if (await validateDocumentExist(collectionPath, documentId)) {
        throw FirebaseException(
            code: '', message: "Document exists", plugin: '');
      } else {
        await db.collection(collectionPath).doc(documentId).set(data);
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> addDocumentWithRandomDocId(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      await db.collection(collectionPath).add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAllDocument(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      final snapshot = await db.collection(collectionPath).get();
      snapshot.docs.forEach((doc) async {
        await doc.reference.update(data);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDocumentByDocumentId(String collectionPath,
      String documentId, Map<String, dynamic> data) async {
    try {
      await db.collection(collectionPath).doc(documentId).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDocumentByGuid(
      String collectionPath, String guid, Map<String, dynamic> data) async {
    try {
      var result = await db
          .collection(collectionPath)
          .where('guid', isEqualTo: guid)
          .get();

      if (result == null) {
        return false;
      } else {
        await db
            .collection(collectionPath)
            .doc(result.docs.map((e) => e.id).elementAt(0))
            .update(data);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDocument(String collectionPath, String documentId) async {
    try {
      await db
          .collection(collectionPath)
          .doc(documentId)
          .delete()
          .onError((error, stackTrace) => {throw Exception()});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDocumentByGuid(String collectionPath, String guid) async {
    try {
      dynamic result = await db
          .collection(collectionPath)
          .where('guid', isEqualTo: guid)
          .get();
      if (result == null) {
        return false;
      } else {
        await db
            .collection(collectionPath)
            .doc(result.docs.map((e) => e.id).first)
            .delete()
            .onError((error, stackTrace) => {throw Exception()});
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> readAllDocument(
      String collectionPath) async {
    return await FirebaseFirestore.instance.collection(collectionPath).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> readByDocumentId(
      String collectionPath, String documentId) async {
    return await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(documentId)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> readByGuid(
      String collectionPath, String guid) async {
    return await FirebaseFirestore.instance
        .collection(collectionPath)
        .where('guid', isEqualTo: guid)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readAllDocumentAsStream(
      String collectionPath) {
    return FirebaseFirestore.instance.collection(collectionPath).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> readByDocumentIdAsStream(
      String collectionPath, String documentId) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(documentId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readByGuidAsStream(
      String collectionPath, String guid) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .where('guid', isEqualTo: guid)
        .snapshots();
  }
}
