import 'package:flutter/material.dart';

import 'package:toolforall_group08_project/classes/item_class.dart';
import 'package:toolforall_group08_project/custom%20widgets/app_bar.dart';
import 'package:toolforall_group08_project/custom%20widgets/home_page_body.dart';

import 'package:toolforall_group08_project/custom%20widgets/item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
        child: FutureBuilder<List<ItemCard>>(
            future: Item().makeItemCards(_searchController.text),
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
