import 'package:flutter/material.dart';

import 'package:toolforall_group08_project/classes/user_class.dart';
import 'package:toolforall_group08_project/custom%20widgets/floating_button.dart';
import 'package:toolforall_group08_project/screens/owner_reviews.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemHistoryRentPage extends StatefulWidget {
  final String returnedDate;
  final String deliveredDate;

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
  final AppUser itemOwner;
  ItemHistoryRentPage(
      {super.key,
      required this.deliveredDate,
      required this.returnedDate,
      required this.itemId,
      required this.title,
      required this.description,
      required this.category,
      required this.days,
      required this.price,
      required this.availability,
      required this.images,
      required this.location,
      required this.latitude,
      required this.longitude,
      required this.publishedDate,
      required this.itemOwner});

  @override
  State<ItemHistoryRentPage> createState() => _ItemHistoryRentPageState();
}

class _ItemHistoryRentPageState extends State<ItemHistoryRentPage> {
  var currentUserId;
  int _currentPage = 0;

  @override
  void initState() {
    currentUserId = fetchCurrentUser();
    super.initState();
  }

  void changePageNumber(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          SizedBox(
            width: double.infinity,
            height: 300.0,
            child: Stack(
              children: [
                PageView(
                  pageSnapping: true,
                  onPageChanged: (pageNumber) {
                    changePageNumber(pageNumber);
                  },
                  children: imageGenerator(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pagenumIndicator(),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  widget.publishedDate.substring(0, 10),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Delivered on: ${widget.deliveredDate}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Returned on: ${widget.returnedDate}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude, widget.longitude),
                  zoom: 14,
                ),
                circles: {
                  Circle(
                    circleId: const CircleId("location"),
                    center: LatLng(widget.latitude, widget.longitude),
                    radius: 200, // Circle radius in meters
                    strokeWidth: 1,
                    strokeColor: Colors.blue,
                    fillColor: Colors.blue.withOpacity(0.5),
                  ),
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About Renter',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  widget.itemOwner.firstname + ' ' + widget.itemOwner.lastname,
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                  //textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => owner_reviewpage(
                                    ownerID: widget.itemOwner.userId)));
                      },
                      child: const Text(
                        'Reviews',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(10)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.call),
                                    title: const Text('Call'),
                                    onTap: () {
                                      // Call the phone number
                                      launchUrl(Uri.parse(
                                          "tel:${widget.itemOwner.number}"));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.message),
                                    title: const Text('SMS'),
                                    onTap: () {
                                      // Send SMS to the phone number
                                      launchUrl(Uri.parse(
                                          "sms:${widget.itemOwner.number}"));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Contact',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  List<Widget> pagenumIndicator() {
    return List.generate(widget.images.length, (index) {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: CircleAvatar(
          radius: 5.0,
          backgroundColor: _currentPage == index
              ? const Color.fromARGB(255, 0, 24, 142)
              : Colors.grey[600],
        ),
      );
    });
  }

  List<Widget> imageGenerator() {
    return List.generate(
      widget.images.length,
      (index) => Image.network(
        widget.images[index],
        fit: BoxFit.cover,
      ),
    );
  }

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
}
