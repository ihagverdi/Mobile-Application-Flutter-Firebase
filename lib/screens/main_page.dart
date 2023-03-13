import 'package:flutter/material.dart';
import 'package:toolforall_group08_project/screens/add_item_page.dart';
import 'package:toolforall_group08_project/screens/home_page.dart';
import 'package:toolforall_group08_project/screens/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initstate() {
    super.initState();
  }

  void _showLogInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Or Register'),
          content:
              const Text('To use this functionality you need to log in first'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
            TextButton(
              child: const Text('Login'),
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  User? user = FirebaseAuth.instance.currentUser;
  int mySelectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const HomePage(),
    const AddItem(),
    //add new item class here
    const UserPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 200, 50),
        height: 60,
        destinations: const [
          NavigationDestination(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          NavigationDestination(
            label: "New Item",
            icon: Icon(Icons.add_circle_outline),
          ),
          NavigationDestination(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
        selectedIndex: mySelectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            if (user != null || value == 0) {
              mySelectedIndex = value;
            } else {
              _showLogInDialog();
            }
          });
        },
      ),
      body: _widgetOptions.elementAt(mySelectedIndex),
    );
  }
}
