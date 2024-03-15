// ignore_for_file: use_build_context_synchronously

import 'package:campus_recruitment/screens/company/bottomnavigation.dart';
import 'package:campus_recruitment/screens/company/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyLogIn extends StatefulWidget {
  const CompanyLogIn({super.key});

  @override
  State<CompanyLogIn> createState() => _CompanyLogInState();
}

class _CompanyLogInState extends State<CompanyLogIn> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController companyemailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true; // Initially obscure the password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Container(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/company login.png",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.9,
                      ),
                      const SizedBox(
                        height: 70.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          controller: companyemailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.black),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              child: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          obscureText: obscurePassword,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formkey.currentState!.validate()) {
                            companyLogIn(companyemailController.text,
                                passwordController.text);
                            // bool isLoginSuccessful = await authenticateUser(
                            //   companyemailController.text,
                            //   passwordController.text,
                            // );

                            // if (isLoginSuccessful) {
                            //   _showSuccessSnackBar("Login successful!");

                            //   Navigator.of(context).pushAndRemoveUntil(
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               const CompanyBottomNavigations()),
                            //       (route) => false);
                            // } else {
                            //   _showErrorSnackBar("Invalid email or password");
                            // }
                          }
                        },
                        child: Center(
                          child: Container(
                            width: 360,
                            height: 55,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Don't have an Account? Create one using",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CompanyRegister(),
                                ),
                              );
                            },
                            child: const Text(
                              "Signup",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future companyLogIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.emailVerified) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('companies')
            .doc(userCredential.user!.uid)
            .get();
        if (userSnapshot.exists) {
          _showSuccessSnackBar('Login Successfull');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const CompanyBottomNavigations(),
            ),
            (route) => false,
          );
        }else{
          _showErrorSnackBar('Invalid User');
        }
      } else {
        _showErrorSnackBar('Please verify your email to login');
      }
    } catch (e) {
      _showErrorSnackBar('Login Error : $e');
    }
  }

  // Future<bool> authenticateUser(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);

  //       if (userCredential.user!.emailVerified == true) {
  //         return true;
  //       }

  //     // If the above line doesn't throw an exception, the login is successful.
  //     // return true;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found' || e.code == 'wrong-password') {
  //       // Handle invalid email or password
  //       print('Invalid email or password');
  //     } else {
  //       // Handle other exceptions
  //       print('Error: $e');
  //     }
  //     return false;
  //   }
  // }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
