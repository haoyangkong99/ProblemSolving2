import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:uuid/uuid.dart';

class CreditCardService {
  FirebaseDbService dbService = FirebaseDbService();
  String collectionPath = "creditCard";
  UserService userService = UserService();

  Future<void> addCreditCard(String cardNumber, String cardHolder, int year,
      int month, int cvc) async {
    var guid = const Uuid().v4();
    User user = await userService.getCurrentUser();
    CreditCard card = CreditCard(
        guid: guid,
        userGuid: user.guid,
        cardHolder: cardHolder,
        cvc: cvc,
        cardNumber: cardNumber,
        month: month,
        year: year);
    await dbService.addDocumentWithRandomDocId(collectionPath, card.toMap());
  }

  Future<bool> updateCreditCardByDocumentId(
      CreditCard creditCard, String documentId) async {
    return await dbService.updateDocumentByDocumentId(
        collectionPath, documentId, creditCard.toMap());
  }

  Future<bool> updateCreditCardByGuid(
      CreditCard creditCard, String guid) async {
    return await dbService.updateDocumentByGuid(
        collectionPath, guid, creditCard.toMap());
  }

  Future<bool> deleteCreditCardByDocumentId(String documentId) async {
    return await dbService.deleteDocument(collectionPath, documentId);
  }

  Future<bool> deleteCreditCardByGuid(String guid) async {
    return await dbService.deleteDocumentByGuid(collectionPath, guid);
  }

  Future<List<CreditCard>> getAllCreditCards() {
    return dbService.readAllDocument(collectionPath).then((value) => value.docs
        .map((creditCard) => CreditCard.fromMap(creditCard.data()))
        .toList());
  }

  Future<CreditCard> getCreditCardByDocumentId(String documentId) {
    return dbService
        .readByDocumentId(collectionPath, documentId)
        .then((value) => CreditCard.fromMap(value.data()));
  }

  Future<CreditCard> getCreditCardByGuid(String guid) {
    return dbService.readByGuid(collectionPath, guid).then((value) => value.docs
        .map((creditCard) => CreditCard.fromMap(creditCard.data()))
        .elementAt(0));
  }

  Future<List<CreditCard>> getCreditCardWithCondition(
      bool Function(CreditCard) condition) {
    return dbService.readAllDocument(collectionPath).then((value) => value.docs
        .map((e) => CreditCard.fromMap(e.data()))
        .where(condition)
        .toList());
  }

  Stream<List<CreditCard>> getAllCreditCardsAsStream() {
    return dbService.readAllDocumentAsStream(collectionPath).map((event) =>
        event.docs.map((e) => CreditCard.fromMap(e.data())).toList());
  }

  Stream<CreditCard> getCreditCardByDocumentIdAsStream(String documentId) {
    return dbService
        .readByDocumentIdAsStream(collectionPath, documentId)
        .map((event) => CreditCard.fromMap(event.data()));
  }

  Stream<CreditCard> getCreditCardByGuidAsStream(String guid) {
    return dbService.readByGuidAsStream(collectionPath, guid).map((event) =>
        event.docs.map((e) => CreditCard.fromMap(e.data())).elementAt(0));
  }

  Stream<List<CreditCard>> getCreditCardsWithConditionAsStream(
      bool Function(CreditCard) condition) {
    return dbService.readAllDocumentAsStream(collectionPath).map((event) =>
        event.docs
            .map((e) => CreditCard.fromMap(e.data()))
            .where(condition)
            .toList());
  }


}
