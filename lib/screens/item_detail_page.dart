import 'package:flutter/material.dart';
import 'package:toolforall_group08_project/classes/request_item_class.dart';
import 'package:toolforall_group08_project/classes/user_class.dart';
import 'package:toolforall_group08_project/custom%20widgets/floating_button.dart';
import 'package:toolforall_group08_project/screens/owner_reviews.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemPage extends StatefulWidget {
  late bool isRequested;

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
  ItemPage(
      {super.key,
      required this.isRequested,
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
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.price.toString() + ' SEK/Day',
              style: TextStyle(
                  fontSize: 25,
                  backgroundColor: Colors.green[400],
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.itemOwner.userId != fetchCurrentUser()
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: widget.availability
                              ? ElevatedButton(
                                  onPressed: widget.isRequested == false
                                      ? () {
                                          if (FirebaseAuth
                                                  .instance.currentUser ==
                                              null) {
                                            _showLogInDialog();
                                          } else {
                                            _showRequestConfirmationDialog();
                                          }
                                        }
                                      : null,
                                  child: Text(widget.isRequested
                                      ? "Requested!"
                                      : "Request Item"),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(300.0, 50.0),
                                    textStyle: const TextStyle(fontSize: 20),
                                    primary: widget.isRequested
                                        ? Colors.red
                                        : const Color.fromARGB(255, 0, 24, 142),
                                    onPrimary: Colors.white,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                  ),
                                )
                              : Text(
                                  'Item is not available',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                        ),
                      )
                    : SizedBox(
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
                Text(
                  '${widget.itemOwner.firstname} ${widget.itemOwner.lastname}',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
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

  void _showLogInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Or Register'),
          content: Text('To request an Item, Login first or create an account'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Register'),
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
            TextButton(
              child: Text('Login'),
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  void _showRequestConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Request'),
          content: Text('Are you sure you want to request the item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _requestItem();
              },
            ),
          ],
        );
      },
    );
  }

  void _requestItem() {
    Request newRequest = Request();

    newRequest.makeRequest(
      itemId: widget.itemId,
      ownerId: widget.itemOwner.userId,
      senderId: currentUserId,
    );
    setState(() {
      widget.isRequested = !widget.isRequested;
    });
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
