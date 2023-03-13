import 'package:flutter/material.dart';
import 'package:toolforall_group08_project/custom%20widgets/horizontal_bar.dart';
import 'package:toolforall_group08_project/custom%20widgets/item_card.dart';
import 'package:toolforall_group08_project/custom%20widgets/item_cards.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key? key,
    required this.itemCards,
    required this.numItems,
  }) : super(key: key);
  final List<Widget> itemCards;
  final int numItems;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          HorizontalBar(
            numItems: numItems,
          ),
          const SizedBox(
            height: 10,
          ),
          ItemCardsGrid(itemCards: itemCards)
        ],
      ),
    );
  }
}
