// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../classes/authentification.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
//
// class EditProfileInfo extends StatefulWidget {
//   @override
//   State<EditProfileInfo> createState() => _EditProfileInfoState();
// }
//
// class _EditProfileInfoState extends State<EditProfileInfo> {
//   User? user = Authentification().getCurrentUser(); // Get current user
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController usernameController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool isDark = false;
//   File? _image;
//   File? _imageFile;
//   String? profileImageUrl;
//   bool isProfileComplete = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//     //if (user != null) {
//      // profileImageUrl = user!.photoURL;
//       _loadUserData();
//    // }
//   }
//   @override
//   Widget build(BuildContext context) {
//     var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
//     const String tprofileHeading = "assets/images/avathar.png";
//
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: Colors.blue[900],
//           title: Text(
//             "Edit Profile",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: Colors.white,
//               )),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   isDark = !isDark;
//                 });
//               },
//               icon: Icon(isDark ? Icons.sunny : Icons.shield_moon),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(40),
//             child: Column(
//               children: [
//                 // Stack(
//                 //   children: [
//                 //     CircleAvatar(
//                 //       radius: 60,
//                 //       backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/images/avathar.png') as ImageProvider,
//                 //     ),
//                 //     Positioned(
//                 //       bottom: 0,
//                 //       right: 0,
//                 //       child: InkWell(
//                 //         onTap: _pickImage,
//                 //         child: Container(
//                 //           width: 35,
//                 //           height: 35,
//                 //           decoration: BoxDecoration(
//                 //             shape: BoxShape.circle,
//                 //             color: Colors.grey.shade300,
//                 //           ),
//                 //           child: Icon(Icons.edit, color: Colors.black),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 60,
//                       backgroundColor: Colors.transparent,
//                       child: _imageFile != null
//                           ? Image.file(
//                         _imageFile!,
//                         fit: BoxFit.cover,
//                       )
//                           : profileImageUrl != null
//                           ? CachedNetworkImage(
//                         imageUrl: profileImageUrl!,
//                         imageBuilder:
//                             (context, imageProvider) =>
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                         placeholder: (context, url) =>
//                         const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                       )
//                           : const Icon(
//                         Icons.account_circle,
//                         size: 120,
//                         color: Color(0xFFBDBDBD),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: const BoxDecoration(
//                           color: Color(0xFF6100FF), // Background color
//                           shape: BoxShape.circle, // Circular shape
//                         ),
//                         child: IconButton(
//                           icon: const Icon(Icons.edit),
//                           color: Colors.white, // Icon color
//                           onPressed: _pickImage,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   user?.displayName ?? "User Name",
//                   // Display name or fallback text
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   user?.email ?? "user@example.com",
//                   // Display email or fallback text
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   width: 200,
//                   child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[900],
//                           side: BorderSide.none,
//                           shape: StadiumBorder()),
//                       child: Text(
//                         "Edit Profile",
//                         style: TextStyle(color: Colors.white),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Divider(),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Form(
//                     key: _formKey,
//                     child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           label: Text("Full Name"),
//                           prefixIcon: Icon(Icons.person)),
//                       controller: usernameController,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextFormField(
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           label: Text("Email"),
//                           prefixIcon: Icon(Icons.mail)),
//                       controller: emailController,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextFormField(
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           label: Text("Phone Number"),
//                           prefixIcon: Icon(Icons.phone)),
//                       controller: phoneController,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextFormField(
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           label: Text("Password"),
//                           prefixIcon: Icon(Icons.password)),
//                       controller: passwordController,
//                     )
//                   ],
//                 )),
//                 //Spacer(),
//                 SizedBox(height: 40,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     OutlinedButton(
//                       onPressed: _cancelChanges,
//                       child: Text("Cancel"),
//                     ),
//                     ElevatedButton(
//                       onPressed: _saveChanges,
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
//                       child: Text("Save", style: TextStyle(color: Colors.white)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
//   void _cancelChanges() {
//     _loadUserData();
//   }
//   Future<void> _saveChanges() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         String? imageUrl = profileImageUrl; // Keep existing profile pic if unchanged
//
//         // If a new image is selected, upload it
//         if (_imageFile != null) {
//           imageUrl = await _uploadProfileImage();
//         }
//
//         // Update Firebase Auth profile (display name & email)
//         await user?.updateDisplayName(usernameController.text);
//         await user?.updateEmail(emailController.text);
//
//         // Reference to Firestore document
//         DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
//
//         // Update Firestore
//         await userDoc.set({
//           'username': usernameController.text,
//           'email': emailController.text,
//           'phone': phoneController.text,
//           'password': passwordController.text,
//           'profileImage': imageUrl, // Save the profile image URL
//           'createdAt': FieldValue.serverTimestamp(),
//         }, SetOptions(merge: true)); // Merge to avoid overwriting
//
//         setState(() {
//           profileImageUrl = imageUrl; // Update UI with new profile image
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile Updated Successfully')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }
//   Future<void> _saveChangeses() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await user?.updateDisplayName(usernameController.text);
//         await user?.updateEmail(emailController.text);
//
//         DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
//         DocumentSnapshot docSnapshot = await userDoc.get();
//
//         if (docSnapshot.exists) {
//           await userDoc.update({
//             'username': usernameController.text,
//             'email': emailController.text,
//             'phone': phoneController.text,
//             'password': passwordController.text,
//             'profile': passwordController.text,
//           });
//         } else {
//           await userDoc.set({
//             'username': usernameController.text,
//             'email': emailController.text,
//             'phone': phoneController.text,
//             'password': passwordController.text,
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//         }
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile Updated Successfully')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: const Icon(
//                   Icons.photo_library,
//                   color: Color(0xFF6100FF),
//                 ),
//                 title: const Text('Photo Library'),
//                 onTap: () async {
//                   Navigator.pop(context,
//                       await picker.pickImage(source: ImageSource.gallery));
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(
//                   Icons.camera_alt,
//                   color: Color(0xFF6100FF),
//                 ),
//                 title: const Text('Camera'),
//                 onTap: () async {
//                   Navigator.pop(context,
//                       await picker.pickImage(source: ImageSource.camera));
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//
//       await _uploadProfileImage(); // Upload after selection
//     }
//   }
//   Future<void> _loadUserData() async {
//     if (user == null) return;
//
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user!.uid)
//         .get();
//
//     if (userDoc.exists) {
//       Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
//
//       setState(() {
//         usernameController.text = data['username'] ?? "";
//         emailController.text = data['email'] ?? "";
//         phoneController.text = data['phone'] ?? "";
//         passwordController.text = data['password'] ?? "";
//         profileImageUrl = data['profileImage'] ?? ""; // Load profile image URL
//       });
//     }
//   }
//   Future _uploadProfileImage() async {
//     if (_imageFile == null || user == null) return;
//
//     try {
//       String fileName = "profile_${user!.uid}.jpg";
//       Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
//
//       UploadTask uploadTask = storageRef.putFile(_imageFile!);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//
//       await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
//         'profileImage': downloadUrl,
//       });
//
//       setState(() {
//         profileImageUrl = downloadUrl;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Profile image updated successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading image: $e')),
//       );
//     }
//   }
// }
//

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  User? user;
  File? _imageFile;
  String? profileImageUrl; // Holds the user's profile image URL

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      profileImageUrl = user!.photoURL;
      _loadUserData();
    }
    //_loadUserData();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      setState(() {
        usernameController.text = data['username'] ?? "";
        emailController.text = data['email'] ?? "";
        phoneController.text = data['phone'] ?? "";
        passwordController.text = data['password'] ?? "";
        profileImageUrl = data['photoURL'] ?? "";
      });
    }
  }
  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl = profileImageUrl; // Keep old image if no new one selected

        if (_imageFile != null) {
          imageUrl = await _uploadProfileImage();
          if (imageUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload image')),
            );
            return; // Stop if upload fails
          }
        }

        print("Saving Image URL to Firestore: $imageUrl"); // Debugging

        // Update Firestore
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
          'username': usernameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'profileImage': imageUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

// ✅ Update Firebase Auth profile
        await user!.updateDisplayName(usernameController.text);
        await user!.updateEmail(emailController.text);
        await user!.reload(); // Important: refresh current user
        user = FirebaseAuth.instance.currentUser;

        setState(() {
          profileImageUrl = imageUrl!;
          _imageFile = null;
        });


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Updated Successfully')),
        );

        await user!.updateDisplayName(usernameController.text);
        await user!.updateEmail(emailController.text);
        await user!.reload(); // Refresh the user data
        user = FirebaseAuth.instance.currentUser;

      } catch (e) {
        print('Error saving profile: $e'); // Debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfileImage() async {
    if (_imageFile == null || user == null) return null;

    try {
      String fileName = "profile_${user!.uid}.jpg";
      Reference storageRef =
      FirebaseStorage.instance.ref().child('profile_images/$fileName');

      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // ✅ Ensure the download URL is retrieved correctly
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl"); // Debugging

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //backgroundColor: Color(0xFF8B481A),
          //backgroundColor: Color(0xFF44140F),
          title: Text("Edit Profile", style: TextStyle(color: Colors.red,fontSize: 28)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.red),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (profileImageUrl != null &&
                                profileImageUrl!.isNotEmpty)
                            ? CachedNetworkImageProvider(profileImageUrl!)
                            : AssetImage('assets/images/avathar.png')
                                as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          //color: Color(0xFF44140F),
                          shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(user?.displayName ?? "User Name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(user?.email ?? "user@example.com",
                  style: TextStyle(color: Colors.grey)),
              SizedBox(height: 20),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Full Name",
                            prefixIcon: Icon(Icons.person,
                              //color: Color(0xFF44140F)
                              )),
                        controller: usernameController,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                            prefixIcon: Icon(Icons.mail,
                             // color: Color(0xFF44140F),
                            )),
                        controller: emailController,
                      ),

                      SizedBox(height: 10),
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //       border: OutlineInputBorder(),
                      //       labelText: "Password",
                      //       prefixIcon: Icon(Icons.phone,color: Color(0xFF44140F)
                      //         ,),),
                      //   controller: passwordController,
                      // ),
                    ],
                  )),
              SizedBox(height: 650,child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: _loadUserData, child: Text("Cancel",style: TextStyle(color: Colors.white),)),
                  OutlinedButton(
                      onPressed: _saveChanges, child: Text("Save", style: TextStyle(color: Colors.white),)),
                ],
              ),
             ),
            ],
          ),
        ));
  }
}


// Future<void> _saveChanges() async {
//   if (_formKey.currentState!.validate()) {
//     try {
//       String? imageUrl = profileImageUrl;
//
//       // If a new image is selected, upload it and get the URL
//       if (_imageFile != null) {
//         imageUrl = await _uploadProfileImage();
//       }
//
//       // Update Firebase Auth profile
//       await user?.updateDisplayName(usernameController.text);
//       await user?.updateEmail(emailController.text);
//
//       // Update Firestore document
//       DocumentReference userDoc =
//           FirebaseFirestore.instance.collection('users').doc(user?.uid);
//       await userDoc.set({
//         'username': usernameController.text,
//         'email': emailController.text,
//         'phone': phoneController.text,
//         'profileImage': imageUrl, // Save image URL
//         'updatedAt': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true)); // Avoid overwriting existing fields
//
//       setState(() {
//         profileImageUrl = imageUrl; // Update UI with new profile image
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Profile Updated Successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
// }

// Future<String?> _uploadProfileImage() async {
//   if (_imageFile == null || user == null) return null;
//
//   try {
//     String fileName = "profile_${user!.uid}.jpg";
//     Reference storageRef =
//         FirebaseStorage.instance.ref().child('profile_images/$fileName');
//
//     UploadTask uploadTask = storageRef.putFile(_imageFile!);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//
//     return downloadUrl; // Return the uploaded image URL
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error uploading image: $e')),
//     );
//     return null;
//   }
// }
