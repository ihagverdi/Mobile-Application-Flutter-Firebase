import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:toolforall_group08_project/classes/item_class.dart';
import 'package:toolforall_group08_project/custom%20widgets/app_bar.dart';
import 'package:toolforall_group08_project/custom%20widgets/home_page_body.dart';
import 'package:toolforall_group08_project/custom%20widgets/item_card.dart';

class MyItems extends StatefulWidget {
  const MyItems({super.key, required this.userId});
  final String userId;

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  final TextEditingController searchController = TextEditingController();

  bool isRefreshing = false;
  bool isSearched = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        if (searchController.text.isEmpty) {
          isSearched = false;
        } else {
          isSearched = true;
        }
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
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
      appBar: MyAppBar(
          searchController: searchController,
          placeholder: 'Search for my items...'),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: FutureBuilder<List<ItemCard>>(
            future:
                Item().makeUserItemCards(searchController.text, widget.userId),
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
