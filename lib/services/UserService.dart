import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/Address.dart';
import 'package:utmletgo/model/ReviewsLink.dart';
import 'package:utmletgo/model/User.dart';
import 'package:utmletgo/services/FirebaseDbService.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:uuid/uuid.dart';

class UserService {
  FirebaseDbService dbService = FirebaseDbService();
  FirebaseAuthenticationService authService = FirebaseAuthenticationService();
  String collectionPath = "user";
  Future<bool> addUser(
    String userID,
    String email,
    String password,
    String confirm,
    String name,
    String gender,
    String status,
    String campus,
    String contact,
  ) async {
    var guid = Uuid().v4();

    User user = User.complete(
        guid,
        email,
        UserType.user.name,
        name,
        gender,
        status,
        campus,
        contact,
        VisibilityType.allow.name,
        gender == Gender.Male.name
            ? 'https://firebasestorage.googleapis.com/v0/b/utm-let-go.appspot.com/o/default%2Fman%20profile%20icon.png?alt=media&token=367102b1-325b-4a69-83e2-9c59e634f112'
            : 'https://firebasestorage.googleapis.com/v0/b/utm-let-go.appspot.com/o/default%2Flady%20profile%20icon.png?alt=media&token=80698527-9cec-4c5d-8d74-0f828d9ffe7c',
        List.empty(),
        ReviewsLink(),
        List.empty());

    return await dbService.addDocument(collectionPath, userID, user.toMap());
  }

  Future<bool> updateUserByDocumentId(User user, String documentId) async {
    return await dbService.updateDocumentByDocumentId(
        collectionPath, documentId, user.toMap());
  }

  Future<bool> updateUserByGuid(User user, String guid) async {
    return await dbService.updateDocumentByGuid(
        collectionPath, guid, user.toMap());
  }

  Future<bool> deleteUserByDocumentId(String documentId) async {
    return await dbService.deleteDocument(collectionPath, documentId);
  }

  Future<bool> deleteUserByGuid(String guid) async {
    return await dbService.deleteDocumentByGuid(collectionPath, guid);
  }

  Future<List<User>> getAllUsers() {
    return dbService.readAllDocument(collectionPath).then((value) =>
        value.docs.map((user) => User.fromMap(user.data())).toList());
  }

  Future<User> getUserByDocumentId(String documentId) {
    return dbService
        .readByDocumentId(collectionPath, documentId)
        .then((value) => User.fromMap(value.data()));
  }

  Future<User> getUserByGuid(String? guid) {
    return dbService.readByGuid(collectionPath, guid!).then((value) => value
        .docs
        .map((user) => User.fromMap(user.data()))
        .toList()
        .elementAt(0));
  }

  Future<List<User>> getUserWithCondition(bool Function(User) condition) {
    return dbService.readAllDocument(collectionPath).then((value) => value.docs
        .map((e) => User.fromMap(e.data()))
        .where(condition)
        .toList());
  }

  Stream<List<User>> getAllUsersAsStream() {
    return dbService
        .readAllDocumentAsStream(collectionPath)
        .map((event) => event.docs.map((e) => User.fromMap(e.data())).toList());
  }

  Stream<User> getUserByDocumentIdAsStream(String documentId) {
    return dbService
        .readByDocumentIdAsStream(collectionPath, documentId)
        .map((event) => User.fromMap(event.data()));
  }

  Stream<User> getUserByGuidAsStream(String guid) {
    return dbService.readByGuidAsStream(collectionPath, guid).map(
        (event) => event.docs.map((e) => User.fromMap(e.data())).elementAt(0));
  }

  Stream<List<User>> getUserWithConditionAsStream(
      bool Function(User) condition) {
    return dbService.readAllDocumentAsStream(collectionPath).map((event) =>
        event.docs
            .map((e) => User.fromMap(e.data()))
            .where(condition)
            .toList());
  }

  Future<User> getCurrentUser() async {
    return getUserByDocumentId(authService.getUID());
  }

  Stream<User> getCurrentUserAsStream() {
    return getUserByDocumentIdAsStream(authService.getUID());
  }
}
