import 'package:flutter/material.dart';
import 'package:toolforall_group08_project/custom%20widgets/item_card.dart';

class ItemCardsGrid extends StatelessWidget {
  const ItemCardsGrid({super.key, required this.itemCards});
  final List<Widget>? itemCards;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      primary: false,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 15.0,
      childAspectRatio: 0.8,
      children: itemCards!,
    );
  }
}
