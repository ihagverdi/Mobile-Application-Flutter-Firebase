import 'package:firebase_database/firebase_database.dart';

class Review {
  final databaseReference = FirebaseDatabase.instance.ref();
  String ownerID;
  String renterID;
  int numOfStars;
  String description;
  String itemID;
  String renterName;

  Review(
      {required this.renterName,
      required this.ownerID,
      required this.renterID,
      required this.numOfStars,
      required this.description,
      required this.itemID});

  bool add() {
    bool success = false;
    final ownerListRef = databaseReference.child("Users/$ownerID/Reviews");
    final childReference = databaseReference.child("Reviews").push();

    var id = childReference.key.toString();
    ownerListRef.update({'$id': ""});
    childReference.set({
      'renterName': renterName,
      'id': id,
      'ownerID': ownerID,
      'renterID': renterID,
      'numOfStars': numOfStars,
      'description': description,
      'itemID': itemID,
    }).then((_) {
      print('Data added successfully');
      success = true;
    }).catchError((error) {
      print('Error adding data: $error');
      success = false;
    });
    return success;
  }

  Future<dynamic> searchReviewsByOwnerId({
    required String? ownerId,
  }) async {
    final event = await databaseReference
        .child("Reviews")
        .orderByChild("ownerID")
        .equalTo(ownerId)
        .once();

    DataSnapshot snapshot = event.snapshot;
    List<dynamic>? Reviews = [];
    for (var review in snapshot.children) {
      Reviews.add(review.value);
    }
    return Reviews;
  }
}
