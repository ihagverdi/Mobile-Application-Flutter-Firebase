import 'package:flutter/material.dart';

import 'package:toolforall_group08_project/screens/my_items_page.dart';
import 'package:toolforall_group08_project/screens/my_rented_items_page.dart';
import 'package:toolforall_group08_project/screens/my_requests_page.dart';
import 'package:toolforall_group08_project/screens/owner_reviews.dart';
import 'package:toolforall_group08_project/screens/rent_history_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../classes/item_class.dart';
import '../classes/request_item_class.dart';
import '../classes/Review.dart';
import '../classes/user_class.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool _isSearched = false;
  bool loading = true;

  final TextEditingController _searchController = TextEditingController();

  TextEditingController controller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();

  late String userId = FirebaseAuth.instance.currentUser!.uid; //user exists
  late String myemail =
      FirebaseAuth.instance.currentUser!.email!; //anonymous not allowed

  late String firstname = "";
  late String lastname = "";
  late String phonenumber = "";

  late int stars = 0;
  late int nbreviews = 0;
  late int nbitems = 0;
  late int nbrequests = 0;

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(userId);
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text == '') {
          _isSearched = false;
        } else {
          _isSearched = true;
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Full Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              subtitle: Text(
                "$firstname $lastname",
                style: TextStyle(fontSize: 18),
              ),
            ),

            //-------------------- EMAIL --------------------
            ListTile(
              leading: Icon(Icons.email),
              title: Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              subtitle: Text(
                "$myemail",
                style: TextStyle(fontSize: 18),
              ),
              trailing: TextButton(
                onPressed: () async {
                  final email = await openDialog('Email');
                  if (email == null || email.isEmpty) return;

                  EditValue(userId, 'email', email);
                  //setState(() => this.myemail = email);
                },
                child: Text(
                  'Change',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
              ),
            ),

            //-------------------- PHONE --------------------
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                'Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              subtitle: Text(
                phonenumber,
                style: TextStyle(fontSize: 18),
              ),
              trailing: TextButton(
                onPressed: () async {
                  final phoneNumber = await openDialog('Phone Number');
                  if (phoneNumber == null || phoneNumber.isEmpty) return;

                  setState(() => this.phonenumber = phoneNumber);
                  EditValue(userId, 'number', phoneNumber);
                },
                child: Text(
                  'Change',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
              ),
            ),

            //-------------------- REVIEWS --------------------
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            owner_reviewpage(ownerID: userId)));
              },
              leading: Icon(Icons.thumb_up_sharp),
              title: Text(
                'Reviews',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              subtitle: Row(
                children: <Widget>[
                  if (nbreviews == 0) ...[
                    Text(
                      'No review',
                      style: TextStyle(fontSize: 18),
                    ),
                  ] else ...[
                    for (int i = 1; i <= stars; i++) Icon(Icons.star),
                    for (int i = 1; i <= 5 - stars; i++)
                      Icon(Icons.star_border),
                  ],
                  SizedBox(
                    width: 10,
                  ),
                  if (nbreviews > 0) ...[
                    Text(
                      '$stars ($nbreviews reviews)',
                      style: TextStyle(fontSize: 18),
                    ),
                  ]
                ],
              ),
            ),
            // -------------------- ReceivedRequests --------------------

            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyRequestsPage()));
              },
              leading: Icon(Icons.notifications_rounded),
              title: Text(
                'Received requests',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              // subtitle: Text(
              //   '0 requests',
              //   style: TextStyle(
              //     fontSize: 18,
              //   ),
              // ),
              // trailing: CircleAvatar(
              //   child: Text("2"),
              //   backgroundColor: Colors.red,
              // )
            ),

            SizedBox(height: 10.0),
            // -------------------- MyItemsInRent --------------------
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RentedItemsPage()));
              },
              leading: Icon(Icons.add_box_rounded),
              title: Text(
                'Rented Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              // subtitle: Text(
              //   '0 Items',
              //   style: TextStyle(
              //     fontSize: 18,
              //   ),
              // ),
              // trailing: CircleAvatar(
              //   child: Text("2"),
              //   backgroundColor: Colors.red,
              // )
            ),
            //-------------------- ITEMS AND RENT HISTORY --------------------
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyItems(userId: userId)));
              },
              leading: Icon(Icons.ad_units),
              title: Text(
                'My Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              subtitle: Text(
                '$nbitems item(s)',
                style: TextStyle(fontSize: 18),
              ),
            ),

            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RentHistoryPage()));
              },
              leading: Icon(Icons.history),
              title: Text(
                'Rent History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              subtitle: Text(
                "$nbrequests Item(s)",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20.0),
            //-------------------- CHANGE PASSWORD OR DELETE ACCOUNT --------------------
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final newPassword = await ChangePassword();
                  if (newPassword == null || newPassword.isEmpty) return;
                },
                child: Text("Change Password"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10.0),
                  fixedSize: Size(250, 50),
                  textStyle: TextStyle(fontSize: 20),
                  primary: Color(0xff00178E),
                  onPrimary: Colors.white,
                  elevation: 10,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(9.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  DeleteAccount();
                },
                child: Text("Delete Account"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10.0),
                  fixedSize: Size(250, 50),
                  textStyle: TextStyle(fontSize: 20),
                  primary: Color(0xffDB2735),
                  onPrimary: Colors.white,
                  elevation: 10,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(9.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                LogOut();
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> openDialog(field) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Change ' + field),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'new ' + field),
            controller: controller,
            onSubmitted: (_) => submit(),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  submit();
                },
                child: Text('Submit')),
          ],
        ),
      );

  Future<String?> ChangePassword() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autofocus: true,
                decoration: InputDecoration(hintText: 'new password'),
                controller: password,
                obscureText: true,
                onSubmitted: (_) => submit(),
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'repeat password',
                  contentPadding: EdgeInsets.all(10),
                ),
                controller: password2,
                obscureText: true,
                onSubmitted: (_) => submit(),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (password.text == password2.text) {
                    EditValue(userId, "password", password.text);
                  } else
                    showSnackBar(context, "Passwords does not match!");
                },
                child: Text('Submit')),
          ],
        ),
      );

  Future<String?> DeleteAccount() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure you want to delete this account?'),
          actions: [
            TextButton(
                onPressed: () {
                  showSnackBar(context, "Account deleted");
                  DeleteUser(userId);
                  submit();
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Delete Account')),
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
    password.clear();
    password2.clear();
  }

  Future EditValue(id, type, newvalue) async {
    if (type == "password") {
      try {
        await FirebaseAuth.instance.currentUser!.updatePassword(newvalue);
        showSnackBar(context, "Password changed succefully.");
        submit();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackBar(context, "The password provided is too weak.");
        }
      }
      ;
    }

    bool error = false;
    if (type == 'email') {
      try {
        await FirebaseAuth.instance.currentUser!.updateEmail(newvalue);
        showSnackBar(context, "Email changed succefully.");
        //submit();
        setState(() => this.myemail = newvalue);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          error = true;
          showSnackBar(context, "The account already exists for that email.");
        }
      }
    }

    print("====================================== TESTERROR 01 : $error");
    if (type != 'password' && error == false) {
      print("====================================== TESTERROR 02 : NICE");
      final value = FirebaseDatabase.instance.ref().child("Users/" + id);
      value
          .update({
            type: newvalue,
          })
          .then((_) {})
          .catchError((onError) {
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar);
            print("error");
          });
    }
  }

  Future DeleteUser(id) async {
    FirebaseAuth.instance.currentUser!.delete();

    final value = FirebaseDatabase.instance.ref().child("Users/" + id);
    value.remove().then((_) {}).catchError((onError) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar);
      print("error");
    });
  }

  Future LogOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
  }

  void fetchUserData(userid) async {
    //Fetch data of the user
    AppUser myUser = await fetchUser(userid);

    firstname = myUser.firstname;
    lastname = myUser.lastname;
    myemail = myUser.email;
    phonenumber = myUser.number;

    //Get data from Reviews
    Review reviews = Review(
        renterName: '',
        ownerID: '',
        renterID: '',
        numOfStars: 0,
        description: '',
        itemID: '');
    var myreviews = await reviews.searchReviewsByOwnerId(ownerId: userid);
    var starsvalue = [];
    for (var review in myreviews) {
      starsvalue.add(review['numOfStars']);
      nbreviews++;
    }
    if (nbreviews > 0) {
      var starsAvg = starsvalue.reduce((a, b) => a + b) / nbreviews;
      stars = starsAvg.round();
    }

    //Get data from Items
    Item myItem = Item();
    var allItems = await myItem.readAllItems();

    allItems.forEach((element) {
      if (element!['ownerId'] == userid) {
        nbitems++;
        print("==================== ITEM(S) : $nbitems");
      }
    });

    //Get data from Requests
    Request requests = new Request();
    var myrequests = await requests.searchRequestedBySenderId(senderId: userid);
    for (var request in myrequests) {
      if (request['delivery']['returned'] == 'yes') {
        nbrequests++;
      }
    }

    setState(() {
      loading = false;
    });
    print("====================================== LOADING : " +
        loading.toString());
  }
}
