import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toolforall_group08_project/custom%20widgets/item_card.dart';

class Item {
  //Database Instances
  final _database = FirebaseDatabase.instance;
  final _storage = FirebaseStorage.instance;
  //Create a new item and add it to the DB
  void create(
      {required String ownerId,
      required String title,
      required String description,
      required String category,
      required double price,
      required int days,
      bool availability = true,
      required List<XFile> images,
      required double longitude,
      required double latitude,
      required String location}) async {
    final newItemKey = _database.ref().child('Items').push().key;
    List<String> imageURLS =
        []; //A list to store downloadable links for the item images
    try {
      imageURLS = await getImageLinks(images, newItemKey!);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Error adding the item: $e');
      }
    }
    final itemDetails = {
      'itemId': newItemKey,
      'ownerId': ownerId,
      'images': imageURLS,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'days': days,
      'availability': true,
      'location': location,
      'longitude': longitude,
      'latitude': latitude,
      'published_date': DateTime.now().toIso8601String(),
    };

    final String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await _database.ref('Items/$newItemKey').set(itemDetails);
      addItemToUserListings('Users/$userId', newItemKey.toString());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Error adding the item: $e');
      }
    }
  } // end of create()

  //Fetching all items in the DB
  Future<dynamic> readAllItems() async {
    final DatabaseReference databaseReference = _database.ref();
    final DatabaseEvent event = await databaseReference.child("Items").once();
    final DataSnapshot snapshot = event.snapshot;
    List<dynamic>? items = [];
    for (var item in snapshot.children) {
      items.add(item.value);
    }

    return items;
  }

  Future fetchUserItems(String userId) async {
    final db = FirebaseDatabase.instance.ref();
    final List<String> myItems = await readUserItems(userId);
    final userItems = [];
    for (int i = 0; i < myItems.length; i++) {
      String itemId = myItems[i];
      final event = await db.child('Items/$itemId').once();
      final snap = event.snapshot;
      userItems.add(snap.value);
    }
    return userItems;
  }

  Future<List<String>> readUserItems(String userId) async {
    final ref = _database.ref();
    DatabaseEvent event = await ref.child('Users/$userId/listings').once();
    final List<String> myItems = [];
    for (var item in event.snapshot.children) {
      myItems.add(item.value as String);
    }
    return myItems;
  }

  //Uploading images to the DB, and getting downloadable links simultaneously
  Future<List<String>> getImageLinks(List<XFile> images, String itemId) async {
    List<String> imageURLS = [];
    for (int i = 0; i < images.length; i++) {
      final File imageFile = File(images[i].path);
      final imageReference = _storage.ref().child('$itemId/image$i.jpg');
      await imageReference.putFile(imageFile);
      String imageURL = await imageReference.getDownloadURL();
      imageURLS.add(imageURL);
    }
    return imageURLS;
  }

  Future<List<ItemCard>> makeUserItemCards(
      String searchInputText, String userId) async {
    final items = await fetchUserItems(userId);
    final cards = await makeCards(searchInputText, items);
    return cards;
  }

  Future<List<ItemCard>> makeItemCards(String searchInputText) async {
    final items = await readAllItems();
    final cards = await makeCards(searchInputText, items);
    return cards;
  }

  Future<List<ItemCard>> makeCards(String searchInputText, List items) async {
    List<ItemCard> itemCards = [];
    items.forEach((element) {
      if (element['title']
          .toLowerCase()
          .contains(searchInputText.toLowerCase())) {
        itemCards.add(ItemCard(
          ownerId: element['ownerId'],
          itemId: element['itemId'],
          category: element['category'],
          title: element['title'],
          description: element['description'],
          images: objectListToStringList(element['images']),
          availability: element['availability'],
          days: element['days'],
          price: element['price'],
          location: element['location'],
          latitude: element['latitude'],
          longitude: element['longitude'],
          publishedDate: element['published_date'],
        ));
      }
    });

    return itemCards;
  }
}

//Mini helper functions outside the class
List<String> objectListToStringList(List<dynamic> list) {
  return list.map((e) => e.toString()).toList();
}

void addItemToUserListings(String path, String val) async {
  final DatabaseReference userListingsRef =
      FirebaseDatabase.instance.ref().child('$path/listings');
  final String newListing = userListingsRef.push().key!;
  await userListingsRef.update({newListing: val});
}

bool existsImages(List<XFile> images) {
  return images.isEmpty ? false : true;
}
