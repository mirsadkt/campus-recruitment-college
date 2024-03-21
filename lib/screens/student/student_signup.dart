// ignore_for_file: unused_import, use_build_context_synchronously, avoid_print, unused_element, prefer_const_constructors

import 'package:campus_recruitment/screens/student/bottom%20navigation.dart';
import 'package:campus_recruitment/screens/student/studentlogin.dart';
import 'package:campus_recruitment/screens/student/tell%20us%20about%20yourself%20student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool agreedToTerms = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isSignIn = true;

  void toggle() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  Future<void> _registerUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
            valueColor: AlwaysStoppedAnimation(Colors.grey),
            strokeWidth: 5,
          ),
        );
      },
    );

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Close the loading dialog
      Navigator.of(context).pop();

      if (userCredential.user != null) {
        // Send email verification
        await userCredential.user!.sendEmailVerification();

        // Add user details to Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': nameController.text,
          'lastName': lastNameController.text,
          'username': usernameController.text,
          'email': emailController.text,
          'dob': dobController.text,
          'phoneNumber': phoneNumberController.text,
          'userId': userCredential.user!.uid,
          // Add other user details as needed
        });

        Fluttertoast.showToast(
          msg: "User registration successful. Verification email sent.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Tellusstudent()),
        );
      } else {
        _showErrorToast("Error creating user account");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog

      String errorMessage = "Error creating user account";

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "Email address is already in use by another account.";
          break;
        case 'weak-password':
          errorMessage = "The password provided is too weak.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        default:
          errorMessage = "An error occurred while creating the user account.";
      }

      print("Firebase Auth Error: $e");
      _showErrorToast(errorMessage);
    } catch (e) {
      print("Error in registration: $e");
      Navigator.of(context).pop(); // Close the loading dialog
      _showErrorToast("Error creating user account");
    }
  }

  Future<void> _signInUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
            valueColor: AlwaysStoppedAnimation(Colors.grey),
            strokeWidth: 5,
          ),
        );
      },
    );

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.of(context).pop(); // Close the loading dialog

      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const StudentBottomNavigation()),
        );
      } else {
        _showErrorToast("Invalid username or password");
      }
    } catch (e) {
      print("Error in signIn: $e");
      Navigator.of(context).pop(); // Close the loading dialog
      _showErrorToast("Invalid username or password");
    }
  }

  Future<bool> checkIfUsernameExists(String username) async {
    // Replace this with your actual logic to check the database
    // For simplicity, I'm using a dummy list as an example
    List<String> existingUsernames = ['user1', 'user2', 'user3'];

    // Check if the provided username already exists
    return existingUsernames.contains(username);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text = picked.toString().split(' ')[0];
      });
    }
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  bool showpassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 150.0, left: 15, right: 15),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: "First Name",
                                  contentPadding: EdgeInsets.all(12.0),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                controller: lastNameController,
                                decoration: const InputDecoration(
                                  hintText: "Last Name",
                                  contentPadding: EdgeInsets.all(12.0),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            hintText: "User Name",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter user name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showpassword = !showpassword;
                                  });
                                },
                                icon: Icon(showpassword
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_solid)),
                            hintText: "Enter Password",
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          maxLength: 10,
                          obscureText: showpassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: showpassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showpassword = !showpassword;
                                  });
                                },
                                icon: Icon(showpassword
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_solid)),
                            hintText: "Confirm Password",
                            contentPadding: const EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            } else if (value != passwordController.text) {
                              return "does not match the password";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: dobController,
                        decoration: InputDecoration(
                          hintText: "Date of Birth",
                          contentPadding: const EdgeInsets.all(12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date of birth';
                          }
                          return null;
                        },
                        onTap: () {
                          _selectDate(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          hintText: "Enter your Phone number",
                          contentPadding: const EdgeInsets.all(12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Cannot be empty';
                          } else if (value.length != 10) {
                            return 'Must be 10 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              agreedToTerms = value!;
                            });
                          },
                        ),
                         Text(
                          'I agree to the ',
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: 13),
                        ),
                         Text(
                          'terms and privacy policy',
                          style: GoogleFonts.poppins(color: Colors.blue, fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            agreedToTerms) {
                          _registerUser(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(250, 50),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child: Text(
                        "Proceed",
                        style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Already have an Account? ",
                            style:
                                GoogleFonts.poppins(color: Colors.black, fontSize: 13.0),
                          ),
                        ),
                        const SizedBox(
                          width: 7.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            " Login",
                            style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
