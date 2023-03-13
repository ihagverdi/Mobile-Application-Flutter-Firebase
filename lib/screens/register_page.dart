import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Create an account!',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 22,
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                        controller: firstname,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z]+'))
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            labelText: 'First name',
                            hintText: 'enter First name'))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                        controller: lastname,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z]+'))
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            labelText: 'Last Name',
                            hintText: 'enter Last name'))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            labelText: 'Email',
                            hintText: 'enter email'))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                        controller: phonenumber,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\+[0-9]*'))
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            labelText: 'Phone number',
                            hintText: '+46xxxxxxxxx'))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            labelText: 'Password',
                            hintText: 'enter Password'))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                        controller: password2,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            labelText: 'Confirm Password',
                            hintText: 'enter Password'))),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  width: 100,
                  child: TextButton(
                      onPressed: () async {
                        final ref = FirebaseDatabase.instance.ref('/Users');

                        if (password.text == password2.text) {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            final String userId =
                                FirebaseAuth.instance.currentUser!.uid;
                            await ref.update({
                              userId: {
                                "userId": userId.toString(),
                                "firstname": firstname.text,
                                "lastname": lastname.text,
                                "email": email.text,
                                "number": phonenumber.text
                              }
                            });
                            showSnackBar(context, "Success, Account created");
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/main', (route) => false);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showSnackBar(context,
                                  "The password provided is too weak.");
                            } else if (e.code == 'email-already-in-use') {
                              showSnackBar(context,
                                  "The account already exists for that email.");
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        } else {
                          showSnackBar(context, "Passwords do not match!");
                        }
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
                      child: const Text('Register',
                          style: TextStyle(color: Colors.white, fontSize: 15))),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: const Text('Already have an account? Login',
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
