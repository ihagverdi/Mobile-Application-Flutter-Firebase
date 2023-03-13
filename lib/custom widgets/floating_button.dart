import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
      },
      backgroundColor: const Color.fromARGB(255, 255, 200, 50),
      foregroundColor: Colors.black87,
      mini: true,
      child: const Icon(Icons.arrow_back),
    );
  }
}
