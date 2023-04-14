import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:uuid/uuid.dart';

class OfferService {
  FirebaseDbService dbService = FirebaseDbService();
  FirebaseAuthenticationService authService = FirebaseAuthenticationService();
  String collectionPath = "offer";

  Future<String> addOffer(
      ChatMessageType type, double price, String itemGuid) async {
    var guid = const Uuid().v4();
    Offer offer = Offer.complete(
        guid, itemGuid, type.name, OfferStatus.pending.name, price);
    await dbService.addDocumentWithRandomDocId(collectionPath, offer.toMap());
    return guid;
  }

  Future<bool> updateOfferByDocumentId(Offer offer, String documentId) async {
    return await dbService.updateDocumentByDocumentId(
        collectionPath, documentId, offer.toMap());
  }

  Future<bool> updateOfferByGuid(Offer offer, String guid) async {
    return await dbService.updateDocumentByGuid(
        collectionPath, guid, offer.toMap());
  }

  Future<bool> deleteOfferByDocumentId(String documentId) async {
    return await dbService.deleteDocument(collectionPath, documentId);
  }

  Future<bool> deleteOfferByGuid(String guid) async {
    return await dbService.deleteDocumentByGuid(collectionPath, guid);
  }

  Future<List<Offer>> getAllOffers() {
    return dbService.readAllDocument(collectionPath).then((value) =>
        value.docs.map((offer) => Offer.fromMap(offer.data())).toList());
  }

  Future<Offer> getOfferByDocumentId(String documentId) {
    return dbService
        .readByDocumentId(collectionPath, documentId)
        .then((value) => Offer.fromMap(value.data()));
  }

  Future<Offer> getOfferByGuid(String guid) {
    return dbService.readByGuid(collectionPath, guid).then((value) =>
        value.docs.map((offer) => Offer.fromMap(offer.data())).elementAt(0));
  }

  Future<List<Offer>> getOfferWithCondition(bool Function(Offer) condition) {
    return dbService.readAllDocument(collectionPath).then((value) => value.docs
        .map((e) => Offer.fromMap(e.data()))
        .where(condition)
        .toList());
  }

  Stream<List<Offer>> getAllOffersAsStream() {
    return dbService.readAllDocumentAsStream(collectionPath).map(
        (event) => event.docs.map((e) => Offer.fromMap(e.data())).toList());
  }

  Stream<Offer> getOfferByDocumentIdAsStream(String documentId) {
    return dbService
        .readByDocumentIdAsStream(collectionPath, documentId)
        .map((event) => Offer.fromMap(event.data()));
  }

  Stream<Offer> getOfferByGuidAsStream(String guid) {
    return dbService.readByGuidAsStream(collectionPath, guid).map(
        (event) => event.docs.map((e) => Offer.fromMap(e.data())).elementAt(0));
  }

  Stream<List<Offer>> getOffersWithConditionAsStream(
      bool Function(Offer) condition) {
    return dbService.readAllDocumentAsStream(collectionPath).map((event) =>
        event.docs
            .map((e) => Offer.fromMap(e.data()))
            .where(condition)
            .toList());
  }
}
