import 'package:flutter/material.dart';

class HorizontalBar extends StatelessWidget {
  const HorizontalBar({
    Key? key,
    required this.numItems,
  }) : super(key: key);
  final int numItems;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$numItems Items",
          style: const TextStyle(
            fontSize: 16.0,
            color: Color.fromARGB(255, 0, 24, 142),
          ),
        ),
      ],
    );
  }
}
