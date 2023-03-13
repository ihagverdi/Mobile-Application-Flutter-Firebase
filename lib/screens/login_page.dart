import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                const Text('Welcome back!', style: TextStyle(fontSize: 30)),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            labelText: 'Email',
                            hintText: 'Enter Email'))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            labelText: 'Password',
                            hintText: 'enter Password'))),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  width: 125,
                  child: TextButton(
                      onPressed: () async {
                        //Navigator.pushNamed(context, '/main'),
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: password.text);

                          Navigator.pushNamedAndRemoveUntil(
                              context, '/main', (route) => false);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar(context, "User not found");
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(context, "Wrong password");
                          } else {
                            showSnackBar(context, "User not found");
                          }
                        }
                        //updateDatabase(),
                        //_buildPopupDialog(context),
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 0, 24, 142)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 0, 24, 142))))),
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white, fontSize: 15))),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text('Do not have an account? Register!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontStyle: FontStyle.italic))),
              ],
            ),
          ),
        ),
      ));
}
