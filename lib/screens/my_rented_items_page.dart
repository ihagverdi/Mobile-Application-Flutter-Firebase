import 'package:flutter/material.dart';
import 'package:toolforall_group08_project/classes/request_item_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:toolforall_group08_project/custom%20widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class RentedItemsPage extends StatefulWidget {
  const RentedItemsPage({super.key});

  @override
  State<RentedItemsPage> createState() => _RentedItemsPageState();
}

class _RentedItemsPageState extends State<RentedItemsPage> {
  Request newRequest = Request();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          putBackButton: true,
          title: 'Rented Items',
        ),
        body: FutureBuilder<List<ListTile>>(
            future: makeRentedItemsTiles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: snapshot.data!,
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<List<ListTile>> makeRentedItemsTiles() async {
    final List allRequests =
        await newRequest.searchRequestedByOwnerId(ownerId: fetchCurrentUser());
    List<ListTile> listTilesRequests = [];
    for (var element in allRequests) {
      if (element['requestInfo']['delivery']['returned'] == 'no' &&
          element['requestInfo']['status'] == 'accepted') {
        listTilesRequests.add(ListTile(
          leading: Image(
            image: NetworkImage('${element['itemInfo']['images'][0]}'),
          ),
          title: Text('${element['itemInfo']['title']}'),
          subtitle: Text(
              'Requested by ${element['senderInfo']['firstname']} ${element['senderInfo']['lastname']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  final now = DateTime.now();

                  final DateFormat dateFormat = DateFormat('dd/MM/yyyy h:m a');

                  final formattedDate = dateFormat.format(now);
                  if (element['requestInfo']['delivery']['delivered'] == 'no') {
                    newRequest.updateDelivery(
                        element['requestInfo']['requestId'],
                        'yes',
                        element['requestInfo']['delivery']['returned'],
                        formattedDate,
                        element['requestInfo']['delivery']['returnedDate'],
                        element['itemInfo']['itemId']);
                  } else {
                    newRequest.updateDelivery(
                        element['requestInfo']['requestId'],
                        element['requestInfo']['delivery']['delivered'],
                        'yes',
                        element['requestInfo']['delivery']['deliveredDate'],
                        formattedDate,
                        element['itemInfo']['itemId']);
                  }
                  setState(() {});
                },
                child: Text(
                  element['requestInfo']['delivery']['delivered'] == 'no'
                      ? 'Delivered'
                      : 'Returned',
                ),
              ),
              TextButton(
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
                                  "tel:${element['senderInfo']['number']}"));
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.message),
                            title: const Text('SMS'),
                            onTap: () {
                              // Send SMS to the phone number
                              launchUrl(Uri.parse(
                                  "sms:${element['senderInfo']['number']}"));
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
                ),
              ),
            ],
          ),
        ));
      } else {
        continue;
      }
    }
    return listTilesRequests;
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
