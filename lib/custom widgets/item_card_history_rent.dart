import "package:flutter/material.dart";
import 'package:toolforall_group08_project/classes/user_class.dart';
import 'package:toolforall_group08_project/screens/add_review.dart';
import 'package:toolforall_group08_project/screens/item_detail_history_rent.dart';
import 'package:toolforall_group08_project/screens/item_detail_page.dart';
import 'package:toolforall_group08_project/classes/request_item_class.dart';
import 'package:firebase_auth/firebase_auth.dart';

String? fetchCurrentUser() {
  final auth = FirebaseAuth.instance;
  User? user;
  try {
    user = auth.currentUser;
  } catch (e) {
    print('Error getting current user: $e');
    return null;
  }

  return user?.uid;
}

class ItemCardHistoryRent extends StatelessWidget {
  final String ownerId;
  final String itemId;
  final String title;
  final String description;
  final String category;
  final int days;
  final int price;
  final bool availability;
  final List<String> images;
  final String renterId;
  final String location;
  final double latitude;
  final double longitude;
  final String publishedDate;
  final String returnedDate;
  final String deliveredDate;

  const ItemCardHistoryRent({
    Key? key,
    required this.images,
    required this.deliveredDate,
    required this.returnedDate,
    required this.title,
    required this.description,
    required this.location,
    required this.availability,
    required this.renterId,
    required this.ownerId,
    required this.itemId,
    required this.days,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.publishedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FutureBuilder(
                    future: fetchUser(ownerId),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return ItemHistoryRentPage(
                          returnedDate: returnedDate,
                          deliveredDate: deliveredDate,
                          itemId: itemId,
                          title: title,
                          description: description,
                          category: category,
                          days: days,
                          price: price,
                          availability: availability,
                          images: images,
                          location: location,
                          latitude: latitude,
                          longitude: longitude,
                          publishedDate: publishedDate,
                          itemOwner: snapshot.data!,
                        );
                      } else {
                        return Center(
                          child: const CircularProgressIndicator(),
                        );
                      }
                    }),
                  )),
        );
      },
      child: Card(
        elevation: 8.0,
        child: Column(
          children: [
            Expanded(
              child: Image(
                image: NetworkImage(images[0]),
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              title: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              subtitle: Text(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                description,
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                        ),
                        Flexible(
                          child: Text(
                            location,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    child: Text('Review'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => add_review(
                                  ownerID: ownerId,
                                  renterID: renterId,
                                  itemID: itemId,
                                )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Text generateText(bool availability) {
  if (availability) {
    return const Text(
      "available",
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Color.fromARGB(255, 8, 200, 14),
      ),
    );
  }
  return const Text(
    overflow: TextOverflow.ellipsis,
    "not available",
    style: TextStyle(
      color: Color.fromARGB(255, 200, 8, 8),
    ),
  );
}
