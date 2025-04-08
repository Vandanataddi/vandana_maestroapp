// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:storem/screens/login.dart';
//
// class Authentification {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final _emailTextController = TextEditingController();
//   final _passwordTextController = TextEditingController();
//
//   Future<int?> deleteUser() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user = auth.currentUser;
//
//     if (user == null) {
//       print('No user is currently signed in');
//       return null;
//     }
//
//     try {
//       // Reauthenticate the user
//       AuthCredential credential = EmailAuthProvider.credential(
//         email: _emailTextController.text,
//         password: _passwordTextController.text,
//       );
//
//       await user.reauthenticateWithCredential(credential);
//
//       // Delete the user after reauthentication
//       await user.delete();
//       print('User deleted successfully');
//       return 1;
//     } catch (e) {
//       if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
//         print('The user must reauthenticate before deleting their account.');
//         return 2;
//       } else {
//         print('Failed to delete user: $e');
//       }
//     }
//     return 0;
//   }
//
//
//   // Future<int?> deleteUser() async {
//   //   FirebaseAuth auth = FirebaseAuth.instance;
//   //   User? user = auth.currentUser;
//   //
//   //   if (user == null) {
//   //     print('No user is signed in');
//   //     return null;
//   //   }
//   //
//   //   try {
//   //     AuthCredential credential = EmailAuthProvider.credential(
//   //       email: user.email!,
//   //       password: 'user-password', // Prompt user for password
//   //     );
//   //
//   //     await user.reauthenticateWithCredential(credential);
//   //     await user.delete();
//   //     print('User deleted successfully');
//   //     return 1;
//   //   } catch (e) {
//   //     print('Error deleting user: $e');
//   //     return null;
//   //   }
//   // }
//
//   Future<void> signOut(BuildContext context) async {
//     final googleSignIn = GoogleSignIn();
//     await googleSignIn.signOut();
//     await _firebaseAuth.signOut();
//     // Optionally navigate back to the login screen
//     Navigator.of(context).pop();
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (context) => LoginPage()));
//   }
//
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:storem/screens/login.dart';

class Authentification {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Function to get the current user's details
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<int?> deleteUser(String email, String password) async {
    User? user = _firebaseAuth.currentUser;

    // if (user == null) {
    //   print('No user is currently signed in');
    //   return null;
    // }

    try {
      // Reauthenticate the user before deletion
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user?.reauthenticateWithCredential(credential);
      await user?.delete();

      print('User deleted successfully');
      return 1;
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        print('The user must reauthenticate before deleting their account.');
        return 2;
      } else {
        print('Failed to delete user: $e');
      }
    }
    return 0;
  }

  Future<void> signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();

    // Navigate back to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

