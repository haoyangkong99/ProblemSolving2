import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:uuid/uuid.dart';

class ReviewsService {
  FirebaseDbService dbService = FirebaseDbService();
  FirebaseAuthenticationService authService = FirebaseAuthenticationService();
  String collectionPath = "reviews";
  UserService userService = UserService();
  ItemService itemService = ItemService();
  Future<void> addReview(double rating, String message, String itemGuid,
      String reviewerGuid) async {
    var guid = const Uuid().v4();
    Reviews reviews = Reviews.complete(guid, DateTime.now().toString(), message,
        rating, reviewerGuid, itemGuid);
    await dbService.addDocumentWithRandomDocId(collectionPath, reviews.toMap());
    await userService
        .getUserWithCondition(
            (temp) => temp.itemLink.any((element) => element == itemGuid))
        .then((value) => value.elementAt(0))
        .then((x) async {
      x.reviewsLink = calculateAddReviews(x.reviewsLink, reviews);
      await userService.updateUserByGuid(x, x.guid);
      await itemService.getItemByGuid(itemGuid).then((item) async {
        item.reviewsLink = calculateAddReviews(item.reviewsLink, reviews);
        await itemService.updateItemByGuid(item, item.guid);
      });
    });
  }

  ReviewsLink calculateAddReviews(ReviewsLink link, Reviews reviews) {
    double newAverageRating =
        (link.averageRating * link.reviewsCount + reviews.rating.toDouble()) /
            (link.reviewsCount + 1);
    link.averageRating = newAverageRating;
    link.reviewsCount = link.reviewsCount + 1;
    link.reviewsGuid.add(reviews.guid);
    return link;
  }

  ReviewsLink calculateRemoveReviews(ReviewsLink link, Reviews reviews) {
    double newAverageRating =
        (link.averageRating * link.reviewsCount - reviews.rating.toDouble()) /
            (link.reviewsCount - 1);
    link.averageRating = newAverageRating;
    link.reviewsCount = link.reviewsCount - 1;
    link.reviewsGuid.remove(reviews.guid);
    return link;
  }

  Future<void> updateReviewByDocumentId(
      Reviews reviews, String documentId) async {
    await dbService.updateDocumentByDocumentId(
        collectionPath, documentId, reviews.toMap());
  }

  Future<void> updateReviewByGuid(Reviews reviews, String guid) async {
    await dbService.updateDocumentByGuid(collectionPath, guid, reviews.toMap());
  }

  Future<void> deleteReviewByDocumentId(String documentId) async {
    await getReviewsByDocumentId(documentId).then((reviews) async {
      await userService
          .getUserWithCondition((user) => user.reviewsLink.reviewsGuid
              .any((element) => element == reviews.guid))
          .then((value) {
        for (var x in value) {
          x.reviewsLink = calculateRemoveReviews(x.reviewsLink, reviews);
          userService.updateUserByGuid(x, x.guid);
        }
      });

      await itemService
          .getItemWithCondition((item) => item.reviewsLink.reviewsGuid
              .any((element) => element == reviews.guid))
          .then((value) {
        for (var x in value) {
          x.reviewsLink = calculateRemoveReviews(x.reviewsLink, reviews);
          itemService.updateItemByGuid(x, x.guid);
        }
      });
    });
    await dbService.deleteDocument(collectionPath, documentId);
  }

  Future<void> deleteReviewByGuid(String guid) async {
    await getReviewsByGuid(guid).then((reviews) async {
      await userService
          .getUserWithCondition((user) => user.reviewsLink.reviewsGuid
              .any((element) => element == reviews.guid))
          .then((value) {
        for (var x in value) {
          x.reviewsLink = calculateRemoveReviews(x.reviewsLink, reviews);
          userService.updateUserByGuid(x, x.guid);
        }
      });

      await itemService
          .getItemWithCondition((item) => item.reviewsLink.reviewsGuid
              .any((element) => element == reviews.guid))
          .then((value) {
        for (var x in value) {
          x.reviewsLink = calculateRemoveReviews(x.reviewsLink, reviews);
          itemService.updateItemByGuid(x, x.guid);
        }
      });
    });

    await dbService.deleteDocumentByGuid(collectionPath, guid);
  }

  Future<List<Reviews>> getAllReviews() {
    return dbService.readAllDocument(collectionPath).then((value) =>
        value.docs.map((reviews) => Reviews.fromMap(reviews.data())).toList());
  }

  Future<Reviews> getReviewsByDocumentId(String documentId) {
    return dbService
        .readByDocumentId(collectionPath, documentId)
        .then((value) => Reviews.fromMap(value.data()));
  }

  Future<Reviews> getReviewsByGuid(String guid) {
    return dbService.readByGuid(collectionPath, guid).then((value) => value.docs
        .map((reviews) => Reviews.fromMap(reviews.data()))
        .elementAt(0));
  }

  Stream<List<Reviews>> getAllReviewsAsStream() {
    return dbService.readAllDocumentAsStream(collectionPath).map(
        (event) => event.docs.map((e) => Reviews.fromMap(e.data())).toList());
  }

  Stream<Reviews> getReviewsByDocumentIdAsStream(String documentId) {
    return dbService
        .readByDocumentIdAsStream(collectionPath, documentId)
        .map((event) => Reviews.fromMap(event.data()));
  }

  Stream<List<Reviews>> getReviewsByGuidAsStream(String guid) {
    return dbService.readByGuidAsStream(collectionPath, guid).map(
        (event) => event.docs.map((e) => Reviews.fromMap(e.data())).toList());
  }

  Stream<List<Reviews>> getReviewsWithConditionAsStream(
      bool Function(Reviews) condition) {
    return dbService.readAllDocumentAsStream(collectionPath).map((event) =>
        event.docs
            .map((e) => Reviews.fromMap(e.data()))
            .where(condition)
            .toList());
  }
}
