import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toolforall_group08_project/classes/item_class.dart';
import 'package:toolforall_group08_project/custom%20widgets/add_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  /*controllers*/
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  /*---*/

  final _formKey = GlobalKey<FormState>();
  List<XFile> myImages = [];
  final itemCategories = [
    'Drills',
    'Hammers',
    'Screwdrivers',
    'Other',
  ];
  String userId =
      FirebaseAuth.instance.currentUser!.uid; //Id of the current user
  late String _categoryValue;

  late String IPV4;
  String location = "No city input";
  late double longitude;
  late double latitude;

  @override
  void initState() {
    getIPV4adress();
    super.initState();
  }

  Future<void> getIPV4adress() async {
    String URL = 'https://api.ipify.org';
    http.Response response = await http.get(Uri.parse(URL));
    setState(() {
      IPV4 = response.body;
    });
  }

  Future<void> getCity(String ipv4) async {
    String URL =
        'https://api.apilayer.com/ip_to_location/$ipv4?apikey=VBkTYYGINl1sCqPRWFdsi7QMnIkhGG5b';
    http.Response response = await http.get(Uri.parse(URL));
    final json =
        jsonDecode(response.body); //converting api string result to map

    setState(() {
      location = json["city"];
      latitude = json["latitude"];
      longitude = json["longitude"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Add New Item',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return 'Invalid title';
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        enabledBorder: makeInputBorder(),
                        focusedBorder: makeInputBorder(),
                        errorBorder: makeInputBorder(color: Colors.red),
                        focusedErrorBorder: makeInputBorder(color: Colors.red),
                      ),
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return 'Invalid description';
                      },
                      minLines: 5,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        enabledBorder: makeInputBorder(),
                        focusedBorder: makeInputBorder(),
                        errorBorder: makeInputBorder(color: Colors.red),
                        focusedErrorBorder: makeInputBorder(color: Colors.red),
                      ),
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 200,
                        child: DropdownButtonFormField(
                            validator: (val) {
                              if (val != null) {
                                return null;
                              }
                              return 'Invalid category';
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            hint: const Text('Select the category'),
                            items: makeItemCategories(itemCategories),
                            onChanged: (val) {
                              _categoryValue = val;
                            }),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: priceController,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              return null;
                            }
                            return 'Invalid number';
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('^[0-9]+.?[0-9]*'))
                          ],
                          decoration: InputDecoration(
                            label: const Text('Daily Rental price (SEK)'),
                            hintText: '50 SEK',
                            prefixIcon: const Icon(Icons.monetization_on),
                            enabledBorder: makeInputBorder(borderRadius: 4),
                            focusedBorder: makeInputBorder(borderRadius: 4),
                            errorBorder: makeInputBorder(
                                borderRadius: 4, color: Colors.red),
                            focusedErrorBorder: makeInputBorder(
                                borderRadius: 4, color: Colors.red),
                          ),
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: daysController,
                          validator: (value) {
                            if (value != null && value != '0') {
                              return null;
                            }
                            return 'Invalid number';
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            label: const Text('Number of days available'),
                            prefixIcon: const Icon(Icons.calendar_month),
                            enabledBorder: makeInputBorder(borderRadius: 4),
                            focusedBorder: makeInputBorder(borderRadius: 4),
                            errorBorder: makeInputBorder(
                                borderRadius: 4, color: Colors.red),
                            focusedErrorBorder: makeInputBorder(
                                borderRadius: 4, color: Colors.red),
                          ),
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {});
                        getCity(IPV4).whenComplete(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('City $location has been added'),
                          ));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: const Color.fromARGB(255, 0, 24, 142),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Get my location',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddImage(myImages: myImages),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (!existsImages(myImages)) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Please upload at least one image'),
                            ));
                          } else {
                            Item myItem = Item();
                            myItem.create(
                                latitude: latitude,
                                longitude: longitude,
                                title: titleController.text,
                                category: _categoryValue,
                                description: descriptionController.text,
                                images: myImages,
                                location: location.toString(),
                                ownerId: userId,
                                price: double.parse(priceController.text),
                                days: int.parse(daysController.text));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Item is added'),
                            ));
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/main', (route) => false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: const Color.fromARGB(255, 0, 24, 142),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Add Item',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<DropdownMenuItem> makeItemCategories(List categories) {
  final result = <DropdownMenuItem>[];
  for (int i = 0; i < categories.length; i++) {
    result.add(DropdownMenuItem(
      value: categories[i],
      child: Text(categories[i].toString()),
    ));
  }
  return result;
}

OutlineInputBorder makeInputBorder(
    {double borderRadius = 20, Color color = Colors.grey}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(
      color: color,
    ),
  );
}
