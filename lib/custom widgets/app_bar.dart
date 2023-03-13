import 'package:flutter/material.dart';
import 'package:toolforall_group08_project/custom%20widgets/search_bar_widget.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  const MyAppBar({
    Key? key,
    this.searchController = null,
    this.putBackButton = false,
    this.placeholder = 'Search..',
    this.title = null,
  }) : super(key: key);

  final bool putBackButton;
  final TextEditingController? searchController;
  final String placeholder;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70.0,
      backgroundColor: const Color.fromARGB(255, 255, 200, 50),
      leading: putBackButton == true
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
            )
          : null,
      title: searchController == null
          ? Text(
              title!,
              style: TextStyle(color: Colors.black87),
            )
          : SearchBar(
              searchController: searchController!,
              placeholder: placeholder,
            ),
    );
  }
}
