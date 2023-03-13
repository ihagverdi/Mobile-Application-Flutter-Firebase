import 'package:flutter/material.dart';
import 'package:toolforall_group08_project/classes/request_item_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toolforall_group08_project/custom%20widgets/app_bar.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  Request newRequest = Request();
  @override
  void initState() {
    final database = FirebaseDatabase.instance;
    // TODO: implement initState
    database.ref().child('/Requests').onChildChanged.listen((event) {
      setState(() {});
    });
    database.ref().child('/Requests').onChildRemoved.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          putBackButton: true,
          title: 'Received Requests',
        ),
        body: FutureBuilder<List<ListTile>>(
            future: makeRequestsTiles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: snapshot.data!,
                  ),
                );
              } else {
                print(snapshot.error);

                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<List<ListTile>> makeRequestsTiles() async {
    final List allRequests =
        await newRequest.searchRequestedByOwnerId(ownerId: fetchCurrentUser());
    List<ListTile> listTilesRequests = [];
    for (var element in allRequests) {
      if (element['requestInfo']['status'] == 'pending') {
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
                  newRequest.updateStatus(element['requestInfo']['requestId'],
                      "accepted", element['itemInfo']['itemId']);
                  newRequest.removeRequests(element['itemInfo']['itemId'],
                      element['requestInfo']['requestId']);
                },
                child: const Text(
                  'Accept',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  newRequest
                      .removeSingleRequest(element['requestInfo']['requestId']);
                },
                child: const Text(
                  'Decline',
                  style: TextStyle(
                    color: Colors.red,
                  ),
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
