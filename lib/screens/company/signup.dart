import 'package:campus_recruitment/screens/company/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyRegister extends StatefulWidget {
  const CompanyRegister({super.key});

  @override
  State<CompanyRegister> createState() => _CompanyRegisterState();
}

class _CompanyRegisterState extends State<CompanyRegister> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfrmPassword = true;

  var companyNameController = TextEditingController();
  var companyemailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var addressController = TextEditingController();
  var companyLicNo = TextEditingController();
  var phoneNoController = TextEditingController();
  List<bool> isCheckedList = [false]; // Initial value

  Future<void> _createAccount(BuildContext context) async {
    try {
      // Validate email format
      if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
          .hasMatch(companyemailController.text)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.',
        );
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: companyemailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        // Send email verification
        await userCredential.user!.sendEmailVerification();

        // Add user details to Firestore collection
        await _firestore
            .collection('companies')
            .doc(userCredential.user!.uid)
            .set({
          'companyId': userCredential.user!.uid,
          'companyname': companyNameController.text,
          'email': companyemailController.text,
          'address': addressController.text,
          'companyLicNo': companyLicNo.text,
          'phoneNo': phoneNoController.text,
          'website': null,
          'industry':null,
          'about':null,
          'userlogo':null
        });

        // Navigate to the next screen or perform any other action
        // ...

        print("Company registration successful");

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Company registration successful. Verification email sent.'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Error in registration: $e");

      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error in registration: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*this field is required';
                      } else {
                        return null;
                      }
                    },
                    controller: companyNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Company Name',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*this field is required';
                      } else {
                        return null;
                      }
                    },
                    controller: companyemailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*this field is required';
                      } else {
                        return null;
                      }
                    },
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: phoneNoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Phone',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*this field is required';
                      } else {
                        return null;
                      }
                    },
                    controller: companyLicNo,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Company Lic No.',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*this field is required';
                      } else {
                        return null;
                      }
                    },
                    controller: passwordController,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Password',
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
                    obscureText: obscurePassword,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*this field is required';
                      } else if (value != passwordController.text) {
                        return "Password didnot match";
                      } else {
                        return null;
                      }
                    },
                    controller: confirmPasswordController,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                      suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureConfrmPassword = !obscureConfrmPassword;
                              });
                            },
                            child: Icon(
                              obscureConfrmPassword == false
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                    ),
                    obscureText: obscureConfrmPassword,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*this field is required';
                      } else {
                        return null;
                      }
                    },
                    controller: addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Company Address',
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16.0),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Row(
                      children: [
                        Text('I agree to the '),
                        Expanded(
                          child: Text(
                            'Terms & service policy',
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: isCheckedList[0],
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedList[0] = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          isCheckedList[0]) {
                        _createAccount(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Create Account'),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CompanyLogIn(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            decorationThickness: 2,
                          ),
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
}
