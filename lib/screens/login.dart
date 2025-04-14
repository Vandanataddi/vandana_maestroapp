import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:storem/classes/firebase_auth.dart';
import 'package:storem/helper/helper.dart';
import 'package:storem/screens/register.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../classes/validator.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _obscureText = true;
  bool apiCall = false;

  Future<void> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await auth.signOut();
  }
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    return firebaseApp;
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Login Page'),
      ),
      body: Container(
        color: const Color(0xFFF3F8FF),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 24),
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 48),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder()),
                        controller: _emailTextController,style: TextStyle(color:Colors.grey[700]),
                        validator: (value) =>
                            Validator.validateEmail(email: value),
                      ),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style:
                          TextStyle(fontSize: 16, color:Colors.black),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                              color: Colors.black
                              ),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              }
                            },
                          ),
                        ),
                        controller: _passwordTextController,style: TextStyle(color: Colors.grey[700]),
                        obscureText: _obscureText,
                        validator: (value) =>
                            Validator.validatePassword(password: value),
                      ),
                      const SizedBox(height: 32.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (mounted) {
                                setState(() {
                                  apiCall = true;
                                });
                              }
                              try {
                                User? user = await FireAuth.signInUsingEmailPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text,
                                );

                                if (user != null) {
                                  print("User signed in successfully: ${user.email}");

                                  // if (user.emailVerified) {
                                    final userProfile = await FireAuth.getUserProfile(user.uid);
                                    print("User Profile: $userProfile");

                                    if (mounted) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => MyApp()),
                                      );
                                    }
                                  // }
                                  // else {
                                  //   Helper.showFlashError(context, "Please verify your email before logging in.", Colors.red);
                                  // }
                                }
                            else {
                                  Helper.showFlashError(
                                    context,
                                    "Invalid email or password.",
                                    Colors.red,
                                  );
                                }
                              } catch (e) {
                                Helper.showFlashError(
                                  context,
                                  "Error: ${e.toString()}",
                                  Colors.red,
                                );
                              }
                              if (mounted) {
                                setState(() {
                                  apiCall = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                           // backgroundColor: const Color(0xFF44140F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: apiCall
                              ? Image.asset(
                            'assets/images/loader.gif',
                            width: 28,
                            height: 28,
                          )
                              : const Text(
                            'Login',
                            style: TextStyle(fontSize: 16.0, ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ",style: TextStyle(color: Colors.black)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const RegisterView()),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text("Or", style: TextStyle(color: Colors.black),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
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
                            // SignInButton(
                            //       Buttons.apple,
                            //       elevation: 2,
                            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0),),
                            //       onPressed: () {
                            //         signInWithApple(context: context, scopes: [Scope.email, Scope.fullName]);
                            //       },
                            //     ),
                          ],
                        ),
                      ),
                      // ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: Image.asset(
                'assets/images/loader.gif',
                width: 28,
                height: 28,
              ),
            );
          },
        ),
      ),
    );
  }
}
