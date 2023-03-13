import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toolforall_group08_project/classes/Review.dart';

class add_review extends StatefulWidget {
  final String ownerID;
  final String renterID;
  final String itemID;

  add_review(
      {Key? key,
      required this.ownerID,
      required this.renterID,
      required this.itemID})
      : super(key: key);

  @override
  add_reviewstate createState() => add_reviewstate();
}

class add_reviewstate extends State<add_review> {
  late String renterName = "";
  Future<dynamic> getName(String uid) async {
    final ref = await FirebaseDatabase.instance.ref("Users/$uid");
    final nameref = await ref.child("firstname").get();

    if (nameref.exists) {
      return nameref.value.toString();
    }
  }

  int _numOfStars = 1;
  late String _description;

  final _formKey = GlobalKey<FormState>();

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var review = Review(
        renterName: renterName,
        ownerID: widget.ownerID,
        renterID: widget.renterID,
        numOfStars: _numOfStars,
        description: _description,
        itemID: widget.itemID,
      );
      review.add();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    getName(widget.renterID).then((result) {
      setState(() {
        renterName = result;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 255, 200, 50),
        title: const Text(
          'Add Review',
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 0, 24, 142)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 24, 142)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 24, 142)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                  maxLines: null,
                  expands: true,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Number of stars:'),
              Row(
                children: List.generate(
                  5,
                  (index) => Expanded(
                    child: IconButton(
                      icon: _numOfStars > index
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border),
                      color: const Color.fromARGB(255, 255, 200, 50),
                      onPressed: () => setState(() => _numOfStars = index + 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 0, 24, 142))),
                onPressed: _submitReview,
                child: const Text(
                  'Submit Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
