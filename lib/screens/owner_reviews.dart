import 'package:flutter/material.dart';
import 'package:toolforall_group08_project/classes/Review.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toolforall_group08_project/custom widgets/review_widget.dart';
import 'package:toolforall_group08_project/custom%20widgets/app_bar.dart';

class owner_reviewpage extends StatefulWidget {
  final String ownerID;

  const owner_reviewpage({super.key, required this.ownerID});

  @override
  owner_reviewpagestate createState() => owner_reviewpagestate();
}

class owner_reviewpagestate extends State<owner_reviewpage> {
  Map reviews = {};

  @override
  void initState() {
    super.initState();
    // Fetch the reviews for the item
    getReviews();
  }

  Future<Map<String, dynamic>> getReviews() async {
    Map<String, dynamic> reviewData = {};

    final ref = FirebaseDatabase.instance.ref();
    final reviewReference = await ref.child("Reviews").get();

    if (reviewReference.exists) {
      Map<dynamic, dynamic> reviews = reviewReference.value as Map;
      reviews.forEach((key, value) {
        if (widget.ownerID == value['ownerID']) {
          String reviewID = key;
          String description = value['description'];
          int numOfStars = value['numOfStars'];
          String name = value['renterName'];
          reviewData[reviewID] = {
            'description': description,
            'numOfStars': numOfStars,
            'name': name
          };
        }
      });
    }
    return reviewData;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const MyAppBar(
          title: 'Reviews',
          putBackButton: true,
        ),
        body: FutureBuilder(
          future: getReviews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic>? reviews = snapshot.data;
              return ListView.builder(
                itemCount: reviews?.length,
                itemBuilder: (context, index) {
                  String reviewID = reviews!.keys.toList()[index];
                  String description = reviews[reviewID]['description'];
                  int numOfStars = reviews[reviewID]['numOfStars'];
                  String name = reviews[reviewID]['name'];
                  return ReviewTile(
                      stars: numOfStars, review: description, username: name);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
}

// A widget that displays a single review
class ReviewWidget extends StatelessWidget {
  final Review review;

  const ReviewWidget({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name holder", style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 8),
          Text(review.description,
              style: Theme.of(context).textTheme.bodyText2),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Rating: ${review.numOfStars}'),
              const SizedBox(width: 8),
              Text('By: ${review.renterID}'),
            ],
          ),
        ],
      ),
    );
  }
}
