import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toolforall_group08_project/custom%20widgets/item_card.dart';
import 'package:toolforall_group08_project/custom%20widgets/item_card_history_rent.dart';

class Request {
  final database = FirebaseDatabase.instance;
  void makeRequest({
    required String ownerId,
    required String itemId,
    required String? senderId,
  }) async {
    final newRequestKey = database.ref().child('Requests').push().key;
    final requestDetails = {
      'requestId': newRequestKey,
      'ownerId': ownerId,
      'itemId': itemId,
      'senderId': senderId,
      'status': 'pending',
      'delivery': {
        'delivered': 'no',
        'returned': 'no',
        'deliveredDate': 'none',
        'returnedDate': 'none'
      }
    };
    try {
      await database.ref('/Requests/$newRequestKey').set(requestDetails);
    } on FirebaseException catch (e) {
      print('Error occurred: $e');
    }
  }

  void updateStatus(String requestId, String status, String itemId) async {
    final databaseReference = database.ref();
    databaseReference.child('/Requests/$requestId').update({
      'status': status,
    });
    if (status == "accepted") {
      databaseReference.child('/Items/$itemId').update({
        'availability': false,
      });
    }
  }

  void removeSingleRequest(String requestId) {
    final databaseReference = database.ref();
    databaseReference.child('/Requests/$requestId').remove();
  }

  // void removeSingleRequestByItemId(String itemId, String senderId) async {
  //   final databaseReference = database.ref();
  //   final event = await databaseReference
  //       .child("Requests")
  //       .orderByChild("senderId")
  //       .equalTo(senderId)
  //       .once();
  //   DataSnapshot snapshot = event.snapshot;
  //   Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
  // }

  void removeRequests(String itemId, String requestId) async {
    final databaseReference = database.ref();
    final event = await databaseReference
        .child('/Requests')
        .orderByChild('itemId')
        .equalTo(itemId)
        .once();
    DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

    var requestsInfo = data.values.toList();
    for (var request in requestsInfo) {
      if (request['requestId'] != requestId && request['status'] == 'pending') {
        databaseReference.child('/Requests/${request["requestId"]}').remove();
      }
    }
  }

  void updateDelivery(String requestId, String delivered, String returned,
      String deliveredDate, String returnedDate, String itemId) {
    final databaseReference = database.ref();
    databaseReference.child('/Requests/$requestId').update({
      'delivery': {
        'delivered': delivered,
        'returned': returned,
        'deliveredDate': deliveredDate,
        'returnedDate': returnedDate
      }
    });
    if (returnedDate != "none") {
      databaseReference.child('/Items/$itemId').update({
        'availability': true,
      });
    }
  }

  Future<dynamic> readRequests({
    required String ownerId,
  }) async {
    final databaseReference = database.ref();
    final event = await databaseReference
        .child("Requests")
        .orderByChild("ownerId")
        .equalTo(ownerId)
        .once();
    DataSnapshot snapshot = event.snapshot;
    List<dynamic>? Requests = [];
    for (var request in snapshot.children) {
      Requests.add(request.value);
    }

    return Requests;
  }

  Future<List<ItemCardHistoryRent>> makeItemCards(
      String searchInputText, String? senderId) async {
    final allItems = await searchRequestsBySenderId(senderId: senderId);
    List<ItemCardHistoryRent> itemCards = [];
    if (senderId != null) {
      allItems.forEach((element) {
        if (element['itemInfo']['title']
            .toLowerCase()
            .contains(searchInputText.toLowerCase())) {
          if (element['requestInfo']['delivery']['returned'] == 'yes') {
            itemCards.add(ItemCardHistoryRent(
              returnedDate: element['requestInfo']['delivery']['returnedDate'],
              deliveredDate: element['requestInfo']['delivery']
                  ['deliveredDate'],
              renterId: senderId,
              ownerId: element['itemInfo']['ownerId'],
              itemId: element['itemInfo']['itemId'],
              category: element['itemInfo']['category'],
              title: element['itemInfo']['title'],
              description: element['itemInfo']['description'],
              images: objectListToStringList(element['itemInfo']['images']),
              availability: element['itemInfo']['availability'],
              days: element['itemInfo']['days'],
              price: element['itemInfo']['price'],
              location: element['itemInfo']['location'],
              latitude: element['itemInfo']['latitude'],
              longitude: element['itemInfo']['longitude'],
              publishedDate: element['itemInfo']['published_date'],
            ));
          }
        }
      });
    }

    return itemCards;
  }

  Future<dynamic> searchRequestsBySenderId({
    required String? senderId,
  }) async {
    List<dynamic> requests = [];
    final databaseReference = database.ref();
    var itemIds = [];
    var ownerIds = [];
    final event = await databaseReference
        .child("Requests")
        .orderByChild("senderId")
        .equalTo(senderId)
        .once();

    DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      var requestsInfo = data.values.toList();

      itemIds =
          data.values.map((requests) => requests['itemId'] as String).toList();

      final itemResults = await Future.wait(itemIds.map((itemId) async {
        final itemEvent = await database.ref().child('/Items/$itemId').once();
        DataSnapshot itemSnapshot = itemEvent.snapshot;
        Map<dynamic, dynamic> itemData =
            itemSnapshot.value as Map<dynamic, dynamic>;

        return itemData;
      }));
      ownerIds =
          data.values.map((requests) => requests['ownerId'] as String).toList();

      final ownerResults = await Future.wait(ownerIds.map((ownerId) async {
        final ownerEvent = await database.ref().child('/Users/$ownerId').once();
        DataSnapshot ownerSnapshot = ownerEvent.snapshot;
        Map<dynamic, dynamic> ownerData =
            ownerSnapshot.value as Map<dynamic, dynamic>;

        return ownerData;
      }));

      for (int i = 0; i < itemResults.length; i++) {
        requests.add({
          'requestInfo': requestsInfo[i],
          'itemInfo': itemResults[i],
          'senderInfo': ownerResults[i]
        });
      }
    }

    return requests;
  }

  Future<dynamic> searchRequestedBySenderId({
    required String? senderId,
  }) async {
    final databaseReference = database.ref();
    final event = await databaseReference
        .child("Requests")
        .orderByChild("senderId")
        .equalTo(senderId)
        .once();

    DataSnapshot snapshot = event.snapshot;
    List<dynamic>? Requests = [];
    for (var request in snapshot.children) {
      Requests.add(request.value);
    }

    return Requests;
  }

  Future<dynamic> searchRequestedByOwnerId({
    required String? ownerId,
  }) async {
    List<dynamic> requests = [];
    final databaseReference = database.ref();
    var itemIds = [];
    var senderIds = [];
    final event = await databaseReference
        .child("Requests")
        .orderByChild("ownerId")
        .equalTo(ownerId)
        .once();

    DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      var requestsInfo = data.values.toList();

      itemIds =
          data.values.map((requests) => requests['itemId'] as String).toList();

      final itemResults = await Future.wait(itemIds.map((itemId) async {
        final itemEvent = await database.ref().child('/Items/$itemId').once();
        DataSnapshot itemSnapshot = itemEvent.snapshot;
        Map<dynamic, dynamic> itemData =
            itemSnapshot.value as Map<dynamic, dynamic>;

        return itemData;
      }));
      senderIds = data.values
          .map((requests) => requests['senderId'] as String)
          .toList();

      final senderResults = await Future.wait(senderIds.map((senderId) async {
        final senderEvent =
            await database.ref().child('/Users/$senderId').once();
        DataSnapshot senderSnapshot = senderEvent.snapshot;
        Map<dynamic, dynamic> senderData =
            senderSnapshot.value as Map<dynamic, dynamic>;

        return senderData;
      }));

      for (int i = 0; i < itemResults.length; i++) {
        requests.add({
          'requestInfo': requestsInfo[i],
          'itemInfo': itemResults[i],
          'senderInfo': senderResults[i]
        });
      }
    }

    return requests;
  }

  List<String> objectListToStringList(List<dynamic> list) {
    return list.map((e) => e.toString()).toList();
  }
}
