// ignore_for_file: unused_field, use_build_context_synchronously, avoid_print

import 'package:campus_recruitment/screens/admin/adminhome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/admin.png",
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
                              obscurePassword == false
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
                        if (_formKey.currentState!.validate()) {
                          adminLogin(
                              emailController.text, passwordController.text);
                          // bool isLoginSuccessful = await authenticateUser(
                          //   emailController.text,
                          //   passwordController.text,
                          // );

                          // if (isLoginSuccessful) {
                          //   _showSuccessSnackBar("Login successful!");
                          //   Navigator.of(context).pushAndRemoveUntil(
                          //       MaterialPageRoute(
                          //         builder: (context) => const AdminHome(),
                          //       ),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> authenticateUser(String email, String password) async {
    try {
      // Check if the provided email and password match the admin credentials
      if (email == 'admin@gmail.com' && password == 'Admin@123') {
        // Admin login successful
        return true;
      } else {
        // User is not an admin
        return false;
      }
    } catch (e) {
      // Handle exceptions, if any
      print('Error authenticating user: $e');
      return false;
    }
  }

  Future<bool> checkAdminStatus(String uid) async {
    try {
      DocumentSnapshot adminData =
          await FirebaseFirestore.instance.collection('admin').doc(uid).get();

      // Check if the adminData exists and if necessary fields are present
      return adminData.exists && adminData['isAdmin'] == true;
    } catch (e) {
      // Handle exceptions, e.g., Firestore query error
      print('Error checking admin status: $e');
      return false;
    }
  }

  final firebaseAuth = FirebaseAuth.instance;

  Future adminLogin(String username, String password) async {
    try {
      await  firebaseAuth.signInWithEmailAndPassword(
          email: username, password: password);
          if (firebaseAuth.currentUser!.uid == 'cXkgJ7rEjAcAphpCt8o2lkwjUxj1') {
             Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const AdminHome(),
          ),
          (route) => false);
          }else{
              ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid User')));
          }
          
     
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email / password')));
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
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
