import 'package:flutter/material.dart';

class ReviewTile extends StatefulWidget {
  final String username;
  final int stars;
  final String review;
  const ReviewTile(
      {super.key,
      required this.username,
      required this.stars,
      this.review = ''});

  @override
  State<ReviewTile> createState() => ReviewTilestate();
}

class ReviewTilestate extends State<ReviewTile> {
  @override
  Widget build(BuildContext context) {
    final stars = List.generate(
        5,
        (index) => index < (widget.stars)
            ? const Icon(Icons.star)
            : const Icon(Icons.star_border));
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Container(
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Color.fromARGB(26, 189, 189, 189),
              blurRadius: 10,
            )
          ]),
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.username,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: stars,
            ),
            Text(
              widget.review,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ])),
    );
  }
}
