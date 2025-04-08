import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:storem/main.dart';
import 'package:the_apple_sign_in/scope.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class FireAuth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<User?> signInUsingEmailPassword({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided.");
      } else {
        print("FirebaseAuthException: ${e.message}");
      }
      return null;
    } catch (e) {
      print("Error during sign-in: $e");
      return null;
    }
  }
  // Fetch user email and display name
  static Future<Map<String, String>?> getUserProfile(String uid) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        return {
          'email': user.email ?? 'No email',
          'displayName': user.displayName ?? 'No name',
        };
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
    return null;
  }
  static Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }
  static Future<User?> registerUsingEmailPassword({required String name,required String email,required String password,}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        user = _auth.currentUser;
        //await user?.sendEmailVerification();
      }
      return user;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }
  //static Future<void>{}
Future<void> _signInWithGoogle(BuildContext context) async {
  try {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await auth.signInWithCredential(credential);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()),);
    }
  } catch (error) {
    print("failed...");
    print(error);
  }
}
Future<User?> signInWithApple({required BuildContext context, List<Scope> scopes = const []}) async {
  final appleSignInAvailable = await TheAppleSignIn.isAvailable();
  print(appleSignInAvailable);
  final result = await TheAppleSignIn.performRequests([
    const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  ]);
  print(result);
  switch (result.status) {
    case AuthorizationStatus.authorized:
      final appleIdCredential = result.credential!;

      final oAuthCredential = OAuthProvider('apple.com');

      final credential = oAuthCredential.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
          String.fromCharCodes(appleIdCredential.authorizationCode!));

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final firebaseUser = userCredential.user!;
      print('appleuser: $firebaseUser');

      if (scopes.contains(Scope.fullName)) {
        final fullName = appleIdCredential.fullName;

        if (fullName != null &&
            fullName.givenName != null &&
            fullName.familyName != null) {
          final displayName = '${fullName.givenName} ${fullName.familyName}';
          if (firebaseUser.displayName == null ||
              firebaseUser.displayName!.isEmpty) {
            await firebaseUser.updateDisplayName(displayName);
          }
        } else if (firebaseUser.displayName == null ||
            firebaseUser.displayName!.isEmpty) {
          // Generate a random fruit name with a 4-digit number
          final fruitNames = ['User'];
          final random = Random();
          final randomFruit = fruitNames[random.nextInt(fruitNames.length)];
          final randomDigits = random.nextInt(9000) +
              1000; // generates a number between 1000 and 9999
          final displayName = '$randomFruit$randomDigits';
          await firebaseUser.updateDisplayName(displayName);
        }
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()),);

    case AuthorizationStatus.error:
      print(result.error.toString());

    case AuthorizationStatus.cancelled:
      print(result.error.toString());

    default:
      print("got to default");
  }
}
}

// Sign in method
// static Future<User?> signInUsingEmailPassword({required String email, required String password}) async {
//   try {
//     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     return userCredential.user;
//   } on FirebaseAuthException catch (e) {
//     print("FirebaseAuthException: ${e.code} - ${e.message}");
//     return null;
//   } catch (e) {
//     print("Error during sign-in: $e");
//     return null;
//   }
// }
