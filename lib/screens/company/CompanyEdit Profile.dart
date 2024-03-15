// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class CompanyEditProfile extends StatefulWidget {
//   const CompanyEditProfile({super.key});

//   @override
//   _CompanyEditProfileState createState() => _CompanyEditProfileState();
// }

// class _CompanyEditProfileState extends State<CompanyEditProfile> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _addressController;
//   late TextEditingController _websiteController;
//   late TextEditingController _industryController;
//   late TextEditingController _contactController;
//   late TextEditingController _aboutController;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers with current values
//     _nameController = TextEditingController();
//     _emailController = TextEditingController();
//     _addressController = TextEditingController();
//     _websiteController = TextEditingController();
//     _industryController = TextEditingController();
//     _contactController = TextEditingController();
//     _aboutController = TextEditingController();
//     _fetchCompanyDetails();
//   }

//   void _fetchCompanyDetails() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot<Map<String, dynamic>> snapshot =
//             await FirebaseFirestore.instance
//                 .collection('companies')
//                 .doc(user.uid)
//                 .get();

//         if (snapshot.exists) {
//           setState(() {
//             _nameController.text = snapshot.get('companyname');
//             _emailController.text = snapshot.get('email');
//             _addressController.text = snapshot.get('address');
//             _websiteController.text = snapshot.get('website') ?? '';
//             _industryController.text = snapshot.get('industry') ?? '';
//             _contactController.text = snapshot.get('contact') ?? '';
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching company details: $e');
//     }
//   }

//   void _saveChanges() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection('companies')
//             .doc(user.uid)
//             .update({
//           'companyname': _nameController.text,
//           'email': _emailController.text,
//           'address': _addressController.text,
//           'website': _websiteController.text,
//           'industry': _industryController.text,
//           'contact': _contactController.text,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Profile updated successfully'),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error updating company details: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Company Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: 'Company Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter company name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(labelText: 'Email'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _addressController,
//                   decoration: const InputDecoration(labelText: 'Address'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _websiteController,
//                   decoration: const InputDecoration(labelText: 'Website'),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _industryController,
//                   decoration: const InputDecoration(labelText: 'Industry'),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _contactController,
//                   decoration: const InputDecoration(labelText: 'Contact'),
//                 ),
//                 const SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState?.validate() ?? false) {
//                       _saveChanges();
//                     }
//                   },
//                   child: const Text('Save Changes'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyEditProfile extends StatefulWidget {
  const CompanyEditProfile({super.key});

  @override
  _CompanyEditProfileState createState() => _CompanyEditProfileState();
}

class _CompanyEditProfileState extends State<CompanyEditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;
  late TextEditingController _industryController;
  late TextEditingController _contactController;
  late TextEditingController _aboutController; // Added controller for about

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _websiteController = TextEditingController();
    _industryController = TextEditingController();
    _contactController = TextEditingController();
    _aboutController = TextEditingController(); // Initialize about controller
    _fetchCompanyDetails();
  }

  void _fetchCompanyDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('companies')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          setState(() {
            _nameController.text = snapshot.get('companyname');
            _emailController.text = snapshot.get('email');
            _addressController.text = snapshot.get('address');
            _contactController.text = snapshot.get('phoneNo');
            _websiteController.text = snapshot.get('website') ?? '';
            _industryController.text = snapshot.get('industry') ?? '';
            _aboutController.text =
                snapshot.get('about') ?? ''; // Set about text
          });
        }
      }
    } catch (e) {
      print('Error fetching company details: $e');
    }
  }

  void _saveChanges() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('companies')
            .doc(user.uid)
            .update({
          'companyname': _nameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'website': _websiteController.text,
          'industry': _industryController.text,
          'phoneNo': _contactController.text,
          'about': _aboutController.text, // Save about information
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error updating company details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Company Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Company Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(labelText: 'Website'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _industryController,
                  decoration: const InputDecoration(labelText: 'Industry'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _aboutController,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'About'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _saveChanges();
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
