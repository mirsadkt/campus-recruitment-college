// ignore_for_file: unused_field, unused_local_variable

import 'package:campus_recruitment/screens/student/bottom%20navigation.dart';
import 'package:campus_recruitment/screens/student/student_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentLogIn extends StatefulWidget {
  const StudentLogIn({Key? key}) : super(key: key);

  @override
  State<StudentLogIn> createState() => _StudentLogInState();
}

class _StudentLogInState extends State<StudentLogIn> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  bool obscurePassword = true; // Initially obscure the password
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/login.png",
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
                      controller: emailController,
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
                      controller: userPasswordController,
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
                            obscurePassword == false
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      obscureText: obscurePassword,
                      maxLength: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formkey.currentState!.validate()) {
                        await authenticateUser(
                            emailController.text,
                            userPasswordController.text,
                            context);

                      }
                    },
                    child: Center(
                      child: Container(
                        width: 360,
                        height: 55,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
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
                          style: TextStyle(color: Colors.black, fontSize: 10.0),
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
                              builder: (context) => const SignUp(),
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
    );
  }

  Future<bool> authenticateUser(String email, String password, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      String? userId = await getCurrentUserId();
      if (userId != null) {
        print('User ID: $userId');
        if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
           DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
           if (userSnapshot.exists) {
              Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const StudentBottomNavigation(),
              ),
              (route) => false);
              _showSuccessSnackBar('Login Successfull');
           }else{
            _showErrorSnackBar('Invalid User');
           }
         
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please verify your email')));
        }

        // Navigate to the BottomNavigation screen
      }

      // If the above line doesn't throw an exception, the login is successful.
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Handle invalid email or password
         ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid email or password')));
        print('Invalid email or password');
      } else {
        // Handle other exceptions
        print('Error: $e');
         ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Login error : $e')));
        
      }
      return false;
    }
  }

  Future<String?> getCurrentUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // If the user is not null, return the user ID
        return user.uid;
      } else {
        // If the user is null, handle accordingly (e.g., user not signed in)
        print('No user signed in');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Error getting user ID: $e');
      return null;
    }
  }

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
          onPressed: () async {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
