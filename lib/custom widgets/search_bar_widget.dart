import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.searchController,
    required this.placeholder,
  });
  final TextEditingController searchController;
  final String placeholder;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        filled: true,
        fillColor: Colors.white,
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}
