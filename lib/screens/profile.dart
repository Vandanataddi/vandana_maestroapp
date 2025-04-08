import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storem/classes/authentification.dart';
import 'package:storem/classes/firebase_auth.dart';
import 'package:storem/screens/edit_profile_info.dart';
import 'package:storem/screens/privacy_policy.dart';
import 'package:storem/screens/terms_conditions.dart';
import 'package:storem/screens/update_password.dart';
import 'login.dart';
import '../main.dart';

class AccountSettingsScreen extends StatefulWidget {
  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // backgroundColor: Color(0xFF44140F),
        //backgroundColor: Color(0xFFFBBB8F),
        centerTitle: true,
        title: Text(
          'Account Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'StoreM')));
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildProfileSection(),
          _buildSettingsOption(Icons.person, "Edit Profile", () {}, context),
          _buildSettingsOption(Icons.password, "Password", () {}, context),
          _buildSettingsOption(
              Icons.privacy_tip, "Privacy Policy", () {}, context),
          _buildSettingsOption(
              Icons.description, "Terms and Conditions", () {}, context),
          Divider(
            thickness: 2,
            color: Colors.red,
            //color: Color(0xFF8B481A),
          ),
          SizedBox(
            height: 5,
          ),
          _buildSettingsOption(Icons.logout, "Logout", () {}, context),
          _buildSettingsOption(Icons.delete, "Delete Account", () {
            // var user = FirebaseAuth.instance.currentUser;
            // if (user != null) {
            //   await user.delete();
            //   Navigator.pushReplacementNamed(context, '/login');
            // }
          }, context),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    User? user = Authentification().getCurrentUser(); // Get current user
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/avathar.png'),
        ),
        SizedBox(height: 10),
        Text(
          user?.displayName ?? "User Name", // Display name or fallback text
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          user?.email ?? "user@example.com", // Display email or fallback text
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingsOption(
      IconData icon, String title, VoidCallback onTap, context) {
    return Card(
      //color: Color(0xFFFFC8A3),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        //leading: Icon(icon, color: Color(0xFFFBBB8F)),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          if (title == "Edit Profile") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ));
          } else if (title == "Password") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Updatepassword(),
                ));
          } else if (title == "Privacy Policy") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacypolicyScreen(),
                ));
            //PrivacyPolicydialouge();
          } else if (title == "Terms and Conditions") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsAndConditionsScreen(),
                ));
          } else if (title == "Logout") {
            // await FirebaseAuth.instance.signOut();
            logoutDialouge(context);
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else if (title == "Delete Account") {
            await FirebaseAuth.instance.signOut();
            _showDeleteConfirmationDialog(context);
          }
        },
      ),
    );
  }

  Future logoutDialouge(context) {
    return showModalBottomSheet(
    // backgroundColor: Color(0xFFFBBB8F),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Do you want to logout?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Divider(color: Color(0xFF44140F),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                      height: 20, child: VerticalDivider(color: Colors.grey)),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context); // Close the bottom sheet
                      await FireAuth.signOutUser();
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Logout',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                            color: Colors.red
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
         // backgroundColor: Color(0xFFFBBB8F),
          title: const Text('Confirm Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            TextButton(
              onPressed: () async {
                int? result = await Authentification().deleteUser(
                  emailController.text,
                  passwordController.text,
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                  _handleDeleteResult(context, result);
                }
              },
              child: const Text('Delete',style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _handleDeleteResult(context, int? result) {
    if (result == 1) {
      print("result 1");
      // Successfully deleted
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Deleted successfully",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (result == 2) {
      // Requires reauthentication
      print('Please reauthenticate to delete your account.');

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Your session has expired. Please log in again and try deleting your account.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFF6100FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Deletion failed
      print('Failed to delete the account.');
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width:
                double.infinity, // Make sure the bottom sheet takes full width
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            color: Colors.white,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Failed to delete the account',
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
    }
  }

  void PrivacyPolicydialouge() {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            backgroundColor: Color(0xFFFBBB8F),
            title: Text('Privacy Policy'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                      "Welcome to Storem! Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our mobile application  designed to create stories and activities for self-help regarding any social circumstances or imaginative scenarios. By using our Storem app, you agree to the collection and use of information in accordance with this policy."),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Security of Your Information",
                    style: TextStyle(
                        color: Color(0xFF44140F),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "We take reasonable measures to protect your information from unauthorized access, use, alteration, or destruction. However, no method of transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.")
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ACCEPT'),
              ),
            ],
          ),
        );
      },
    );
  }
}
