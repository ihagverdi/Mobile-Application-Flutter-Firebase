import 'package:flutter/material.dart';

import 'package:toolforall_group08_project/classes/request_item_class.dart';
import 'package:toolforall_group08_project/custom%20widgets/app_bar.dart';
import 'package:toolforall_group08_project/custom%20widgets/home_page_body.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:toolforall_group08_project/custom%20widgets/item_card_history_rent.dart';

class RentHistoryPage extends StatefulWidget {
  const RentHistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RentHistoryPage> createState() => RentHistoryPageState();
}

class RentHistoryPageState extends State<RentHistoryPage> {
  bool isRefreshing = false;
  bool isSearched = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isEmpty) {
          isSearched = false;
        } else {
          isSearched = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPage() async {
    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(searchController: _searchController),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: FutureBuilder<List<ItemCardHistoryRent>>(
            future: Request().makeItemCards(
                _searchController.text, FirebaseAuth.instance.currentUser?.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomeBody(
                    itemCards: snapshot.data!, numItems: snapshot.data!.length);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
