import "package:flutter/material.dart";
import 'package:toolforall_group08_project/classes/user_class.dart';
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

class ItemCard extends StatelessWidget {
  final String ownerId;
  final String itemId;
  final String title;
  final String description;
  final String category;
  final int days;
  final int price;
  final bool availability;
  final List<String> images;

  final String location;
  final double latitude;
  final double longitude;
  final String publishedDate;

  const ItemCard({
    Key? key,
    required this.images,
    required this.title,
    required this.description,
    required this.location,
    required this.availability,
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
      onTap: () async {
        bool isRequested = false;

        Request newRequest = Request();
        var currentUser = fetchCurrentUser();
        var requestedItems =
            await newRequest.searchRequestedBySenderId(senderId: currentUser);
        for (var request in requestedItems) {
          if (request["itemId"] == itemId) {
            if (request["status"] == 'pending') {
              isRequested = true;
            }

            break;
          }
        }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FutureBuilder(
                    future: fetchUser(ownerId),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return ItemPage(
                          isRequested: isRequested,
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
                  generateText(availability),
                ],
              ),
            ),
            //Text(price.toString())
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
