import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storem/screens/login.dart';


class Updatepassword extends StatefulWidget {
  const Updatepassword({super.key});

  @override
  State<Updatepassword> createState() => _UpdatepasswordState();
}

class _UpdatepasswordState extends State<Updatepassword> {

  User? user;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _oldpasswordTextController = TextEditingController();
  final _newpasswordTextController = TextEditingController();
  final _confirmpasswordTextController = TextEditingController();
  bool _oldPasswordObscureText = true;
  bool _newPasswordObscureText = true;
  bool _confirmPasswordObscureText = true;
  bool _apiCall = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _oldpasswordTextController.dispose();
    _newpasswordTextController.dispose();
    _confirmpasswordTextController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    } else if (!RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
        .hasMatch(value)) {
      return 'Password must contain at least one capital letter, one small letter, one number, and one special character';
    }
    return null;
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _apiCall = true;
      });
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Re-authenticate the user
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _oldpasswordTextController.text,
          );
          await user.reauthenticateWithCredential(credential);

          // Update the password
          await user.updatePassword(_newpasswordTextController.text);

          // Log out the user
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage()));
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                width: double
                    .infinity, // Make sure the bottom sheet takes full width
                padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                color: Colors.white,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Password updated successfully. Please log in again',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'wrong-password') {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //       content: Text('The current password is incorrect')),
            // );
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  width: double
                      .infinity, // Make sure the bottom sheet takes full width
                  padding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  color: Colors.white,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'The current password is incorrect',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
            // const SnackBar(
            //   backgroundColor: Colors.white,
            //   content: Text(
            //     'The current password is incorrect',
            //     style: TextStyle(
            //         color: Colors.red,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 16),
            //   ),
            // );
          } else {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //       backgroundColor: Colors.white,
            //       content: Text(
            //         '${e.message}',
            //         style: const TextStyle(
            //             color: Colors.red,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 16),
            //       )),
            // );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  e.toString(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
          );
        }
      } finally {
        setState(() {
          _apiCall = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color myCustomColor = Color(0xFFFBBB8F);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),// Set the body background color
      ),
      body: Container(
        //color: const Color(0xFFF3F8FF), // Set the body background color
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: isLoading
              ? Center(
              child: Image.asset(
                'assets/images/loader.gif',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ))
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _oldpasswordTextController,
                    obscureText: _oldPasswordObscureText,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _oldPasswordObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _oldPasswordObscureText =
                            !_oldPasswordObscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _newpasswordTextController,
                    obscureText: _newPasswordObscureText,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _newPasswordObscureText
                              ? Icons.visibility
                              : Icons.visibility_off, color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _newPasswordObscureText =
                            !_newPasswordObscureText;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmpasswordTextController,
                    obscureText: _confirmPasswordObscureText,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordObscureText =
                            !_confirmPasswordObscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      } else if (value !=
                          _newpasswordTextController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                    Colors.red, // Background color
                      fixedSize: const Size(350, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10), // Border radius
                      ), // Width and height
                    ),
                    child: _apiCall
                        ? Image.asset(
                      'assets/images/loader.gif',
                      width: 28,
                      height: 28,
                    )
                        : Container(
                      //color: const Color(0xFF44140F), // Background color of the text container
                      padding: const EdgeInsets.all(
                          10), // Optional: adjust padding as needed
                      child: const Text(
                        'Update Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16), // Text color
                      ),
                    ),
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
