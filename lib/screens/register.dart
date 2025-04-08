import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:storem/classes/firebase_auth.dart';
import 'package:storem/classes/validator.dart';
import 'package:storem/helper/helper.dart';
import 'package:storem/main.dart';
import 'package:the_apple_sign_in/scope.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
        }
      }
    } catch (error) {
      print("Google sign-in failed: $error");
      Helper.showFlashError(context, "Google sign-in failed", Colors.red);
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

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    User? user = await FireAuth.registerUsingEmailPassword(
      name: _nameTextController.text.trim(),
      email: _emailTextController.text.trim(),
      password: _passwordTextController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      Helper.showFlashError(context, "Oops! This email is already registered", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFF3F8FF)),
      body: Container(
        color: const Color(0xFFF3F8FF),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Center(
                    child: Text("Register", style: TextStyle(fontSize: 28,color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 48),
                  const Text("Display Name",style: TextStyle(color: Colors.black)),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    decoration: const InputDecoration(border: UnderlineInputBorder()),
                    controller: _nameTextController,style: TextStyle(color: Colors.grey[700]),
                    validator: (value) => Validator.validateName(name: value),
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Email",style: TextStyle(color: Colors.black)),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    decoration: const InputDecoration(border: UnderlineInputBorder()),
                    controller: _emailTextController,style: TextStyle(color: Colors.grey[700]),
                    validator: (value) => Validator.validateEmail(email: value),
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Password",style: TextStyle(color: Colors.black)),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,color: Color(0xFF44140F)
                          ,),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    controller: _passwordTextController,style: TextStyle(color: Colors.grey[700]),
                    obscureText: _obscureText,
                    validator: (value) => Validator.validatePassword(password: value),
                  ),
                  const SizedBox(height: 25.0),
                  const Center(child: Text("Or",style: TextStyle(color: Colors.black))),
                  const SizedBox(height: 17.0),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: _signInWithGoogle,
                  //     child: const Text("Sign in with Google"),
                  //   ),
                  // ),
                  Padding(padding: EdgeInsets.fromLTRB(80, 0, 20, 0),child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignInButton(
                        Buttons.google,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0),),
                        onPressed: () {
                          _signInWithGoogle(context);
                        },
                      ),
                      SizedBox(height: 10),
                      SignInButton(
                        Buttons.apple,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0),),
                        onPressed: () {
                          signInWithApple(context: context, scopes: [Scope.email, Scope.fullName]);
                        },
                      ),
                    ],
                  ),),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //backgroundColor: const Color(0xFF44140F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onPressed: _register,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// // FireAuth Class
// class FireAuth {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Register user with email and password
//   // static Future<User?> registerUsingEmailPassword({
//   //   required String name,
//   //   required String email,
//   //   required String password,
//   // }) async {
//   //   try {
//   //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //
//   //     User? user = userCredential.user;
//   //     if (user != null) {
//   //       await user.updateDisplayName(name);
//   //       await user.reload();
//   //       user = _auth.currentUser;
//   //       //await user?.sendEmailVerification();
//   //     }
//   //     return user;
//   //   } catch (e) {
//   //     print("Error during registration: $e");
//   //     return null;
//   //   }
//   // }
//
//   // Sign in method
//   static Future<User?> signInUsingEmailPassword({required String email, required String password}) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
//       return userCredential.user;
//     } catch (e) {
//       print("Error during sign-in: $e");
//       return null;
//     }
//   }
//
//   // Fetch user email and display name
//   static Future<Map<String, String>?> getUserProfile(String uid) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null && user.uid == uid) {
//         return {
//           'email': user.email ?? 'No email',
//           'displayName': user.displayName ?? 'No name',
//         };
//       }
//     } catch (e) {
//       print("Error fetching user profile: $e");
//     }
//     return null;
//   }
// }
