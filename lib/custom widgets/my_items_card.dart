import "package:flutter/material.dart";

class MyItemsCard extends StatelessWidget {
  String image;
  String title;
  MyItemsCard({
    required this.image,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Image(
                fit: BoxFit.cover,
                image: AssetImage(image),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0, left: 5.0),
                      child: Text(
                        maxLines: 2,
                        "$title",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5.0),
                    child: Text("free"),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: "Edit",
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 0, 24, 142),
                    ),
                  ),
                  IconButton(
                    tooltip: "RePost",
                    onPressed: () {},
                    icon: Icon(
                      Icons.refresh,
                      color: Color.fromARGB(255, 0, 24, 142),
                    ),
                  ),
                  IconButton(
                    tooltip: "Delete Item",
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 187, 9, 9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
